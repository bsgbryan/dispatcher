Overview
========

dispatcher is a very simple way to handle a message with a defined action.

	instrumentor = require 'instrumentor'
	modules 		 = { }

	module.exports = (message, spark) ->
		req = message.action

		if !modules[req]
			modules[req] = instrumentor.instrument './promises/' + req
		
		modules[req] message
			.then    	(result) -> spark.send 'response', request: req, result: result
			.fail    	(error ) -> spark.send 'error',    request: req, error:  error
			.progress	(update) -> spark.send 'progress', request: req, update: update