File = require './file'
Module = require 'module'
timespan = require 'time-span'
printTree = require 'print-tree'
ORIGINAL_REQUIRE = Module::require
DEFAULTS = require './defaults'
entryFile = null

start = ()->
	Module::require = (path)->
		parent = process(path)
		stop = timespan()
		result = ORIGINAL_REQUIRE.apply(@, arguments)
		duration = stop()
		
		parent.setLastDuration(duration)
		return result


end = (options={})->
	options = Object.assign {}, DEFAULTS, options
	output = prepareOutput(entryFile, options)

	if options.print
		console.log output

	return output


process = (path)->
	callingFile = getCallingFile()
	parent = new File(callingFile)
	file = new File(path, parent)
	entryFile ||= parent

	parent.add(file)
	return parent


getCallingFile = ()->
	prepareStackTrace_ = Error.prepareStackTrace
	Error.prepareStackTrace = (err, stack)-> return stack

	err = new Error
	result = null
	current = err.stack.shift().getFileName()

	while err.stack.length
		caller = err.stack.shift().getFileName()
		if caller isnt current and not caller.includes('module.js')
			result = caller
			break

	Error.prepareStackTrace = prepareStackTrace_
	return result or '<invalid name>'


prepareOutput = (file, options)->
	o = file.getOutput(options, 0)
	return printTree(o, print:false)


module.exports = {start, end}