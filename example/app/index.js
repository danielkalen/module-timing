var express = require('express')
var cookieParser = require('cookie-parser')

var app = express()

app.use(cookieParser())

app.use((req, res, next)=> {
	res.status(200).send('Hello World')
})

module.exports = app