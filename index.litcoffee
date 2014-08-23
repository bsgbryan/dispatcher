Overview
--------

dispatcher is a very simple way to handle a message with a defined action.

	instrumentor = require 'instrumentor'
	modules 		 = { }

dispatch
--------

	dispatch = (message, spark) ->
		req  = message.action
		path = "#{ module.exports.root }/#{ req }"

		if !modules[req]
			modules[req] = instrumentor.instrument path
		
		modules[req] message
			.then    	(result) -> spark.send 'response', request: req, result: result
			.fail    	(error ) -> spark.send 'error',    request: req, error:  error
			.progress	(update) -> spark.send 'progress', request: req, update: update

	module.exports = 
		dispatch: dispatch
		root: 	  '~'