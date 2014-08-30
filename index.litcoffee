Overview
--------

dispatcher is a very simple way to handle a message with a defined action.

    instrumentor = require 'instrumentor'
    modules      = { }

dispatch
--------

    dispatch = (message, listener) ->
      req  = message.action

      if !modules[req]
        modules[req] = instrumentor.instrument req
      
      modules[req] message
        .then     (result) -> listener.send 'resolve',  action: req, result: result if listener?
        .fail     (error ) -> listener.send 'fail',     action: req, error:  error  if listener?
        .progress (update) -> listener.send 'progress', action: req, update: update if listener?

instrument
----------

    instrument = (module) -> instrumentor.use module

Public interface
----------------

    module.exports = 
      dispatch:   dispatch
      instrument: instrument
