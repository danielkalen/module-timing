var express = require('express')
var cookieParser = require('cookie-parser')
var server = require('./server');

var app = express(server)

app.use(cookieParser())

app.use((req, res, next)=> {
	res.status(200).send('Hello World')
})

module.exports = app