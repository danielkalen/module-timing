chalk = require 'chalk'
resolve = require 'resolve'
Path = require 'path'
mem = require 'mem'
CWD = process.cwd()
CACHE = {}


class File
	constructor: (path, @parent)->
		@children = []
		@durations = {}
		@path = path
		@path = resolveModule(path, @parent) if @parent
		[@name, @isExternal] = determineName(@path)
		@dir = Path.dirname(@path)
		@commondir = if @name.includes('/') then Path.dirname(@name) else @dir

		if CACHE[@name]
			return CACHE[@name]
		else
			CACHE[@name] = @

	add: (file)->
		unless @children.includes(file)
			@children.push(file)

	setLastDuration: (duration)->
		file = @children[@children.length-1]
		@durations[file.name] = duration

	getOutput: (options, duration, depth=0, history=[])->
		SHOW_CHILDREN = @children.length and (depth <= options.depth or (options.depth is false and not @isExternal))
		duration = @calcDuration(duration)
		o = {}
		o.name = switch
			when @isExternal and @parent?.isExternal
				[pkg, rest...] = @name.split('/')
				"#{chalk.blue pkg}/#{rest.join('/')}"
			
			when @isExternal
				[pkg] = @name.split('/')
				"#{chalk.blue pkg}"

			else
				name = @name.replace(@parent.commondir, (dir)-> chalk.dim(dir)) if @parent
				"#{name or @name}"

		o.name += " #{durationString(duration, options, SHOW_CHILDREN)}"

		if SHOW_CHILDREN
			o.children = @children
				.filter (child)-> not history.includes(child.path)
				.map (child)=>
					history.push(child.path)
					return child.getOutput(options, @durations[child.name], depth+1, history)
		
		return o

	calcDuration: (total)->
		childDuration = 0
		
		for child in @children
			childDuration += @durations[child.name]

		total ||= childDuration
		self = total - childDuration
		total = normalizeTime(total)
		self = normalizeTime(self)

		return {total, self}




durationString = ({self, total}, options, SHOW_CHILDREN)->
	self_ = self+'ms'
	total_ = total+'ms'
	color = switch
		when total >= options.slow*1.5 then 'red'
		when total >= options.slow then 'yellow'
		else 'green'
	
	if SHOW_CHILDREN
		return chalk[color]("#{self_}/#{total_}")
	else
		return chalk[color](total_)


normalizeTime = (time)-> switch
	when time is 0 then '0'
	when time < 1 then time.toFixed(2)
	else time.toFixed(0)


determineName = (path)->
	if path.includes('node_modules')
		segments = path.split('node_modules/')
		lastSegment = segments[segments.length-1]
		return [lastSegment, true]
	else
		return [Path.relative(CWD, path), false]


resolveModule = mem (path, parent)->
	resolve.sync(path, basedir:parent.dir)
, cacheKey: (path, parent)-> "#{parent.path}+#{path}"


module.exports = File