# module-timing
[![NPM](https://img.shields.io/npm/v/module-timing.svg)](https://npmjs.com/package/module-timing)
[![NPM](https://img.shields.io/npm/dm/module-timing.svg)](https://npmjs.com/package/module-timing)
[![CircleCI](https://circleci.com/gh/danielkalen/module-timing/tree/master.svg?style=svg)](https://circleci.com/gh/danielkalen/module-timing/tree/master)

Measure module loading (aka `require(...)` calls) and output a breakdown tree allowing you to spot your slowest modules/files.

## Usage
```javascript
require('module-timing').start() // must call before any other modules

require('bluebird')
app = require('./app')
app.listen(80)

require('module-timing').end() // end tracking and print tree to console
```

Outputs:
![preview](example/preview.png?raw=true)


## API
### .start()
Start tracking and measuring all subsequent `require` calls.


### .end([options])
End tracking and print out breakdown tree to console.

#### options
Type: `Object`

##### slow
Type: `number`
Default: `500`

Threshold in ms to determine which files in the console output should be highlighted in red.

##### print
Type: `boolean`
Default: `true`

If true then prints computed module tree to console. Otherwise, it simply returns the tree as a string.

##### depth
Type: `number`

Controls how deep the output tree should expanded to. By default, project files/modules will be expanded indefinetely while `node_modules` modules will stay un-expanded.







## License
MIT © [Daniel Kalen](https://github.com/danielkalen)