// Generated by CoffeeScript 1.7.1
(function() {
  var dispatch, instrumentor, modules;

  instrumentor = require('instrumentor');

  modules = {};

  dispatch = function(message, spark) {
    var path, req;
    req = message.action;
    path = "" + module.exports.root + "/" + req;
    console.log("location " + path);
    if (!modules[req]) {
      modules[req] = instrumentor.instrument(path);
    }
    return modules[req](message).then(function(result) {
      return spark.send('response', {
        request: req,
        result: result
      });
    }).fail(function(error) {
      return spark.send('error', {
        request: req,
        error: error
      });
    }).progress(function(update) {
      return spark.send('progress', {
        request: req,
        update: update
      });
    });
  };

  module.exports = {
    dispatch: dispatch,
    root: '~'
  };

}).call(this);
