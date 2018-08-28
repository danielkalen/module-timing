require('../').start() // must call before any other modules

require('bluebird')
app = require('./app')
// app.listen(80)

require('../').end({slow:250, depth:false}) // end tracking and print tree to console