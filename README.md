Overview
========

dispatcher provides a simple way to process websocket messages that define an action.

dispatcher uses [instrumentor](https://github.com/bsgbryan/instrumentor), allowing you
to wrap dispatched modules in additional behavior.

dispatcher handles requiring modules for you - dispatcher uses the `action` property of your
message as the module name to `require`.

message
-------

`message` is the first argument to the `dispatch` method. The only required property on `message`
is `action`. `message` is passed directly to the module specified by `message.action`, so any other properties on `message` make it to the dispatched module.

How to use
==========

There are three steps to using dispatcher:

Get it
------

```javascript
  var dispatcher = require('dispatcher')
```

Set it's root
-------------

Doing this tells `dispatcher` where you store the modules you're going to dispatch messages to.

```javascript
  dispatcher.root = '/the/common/path/for/all/your/modules'
```

Invoke it
---------

If a listener is passed as the second argument it gets notified of the various promise lifecycle
events (`then`, `progress`, and `fail`). Listeners are described in more detail below.

```javascript
  dispatcher.dispatch(message, listener)
```

You can pass a websocket as a listener. Doing so gives you duplexed websocket communication
essentially for free. You could also wrap express middleware and pass it as a listener for super
simple http request handling.

Listeners
=========

Any module that has a `send` method and takes the correct arguments can be a listener.

`send` has the following signature:

```javascript
  function send (event, info) {
    if (event === 'resolve')
      // info will be { action: message.action, result: dispatched_module_output }
    else if (event === 'fail')
      // info will be { action: message.action, error: dispatched_module_error }
    else if (event === 'progress')
      // info will be { action: message.action, update: dispatched_module_update }
  }
```

Dispatchable
============

An example dispatchable module is shown below:

```javascript
  var q = require('q') // For promises

  module.exports = function get_pizza(message) {
    var deferred = q.defer()

    console.log(message.action) // 'get/pizza', 'get_pizza', or whatever

    // Do some... work
    setTimeout (function pizza_delivered() {
      var slices_left = 8
      var eating      = true

      while (eating) {
        console.log(message.catchphrase) // 'Cowabunga!'
        if (--slices_left == 0)
          eating = false
        deferred.notify('Only ' + slices_left + '!')
      }

      deferred.reslove('I LOVE BEING A TURTLE')
    }, 2000) // Delivery takes time

    return deferred.promise
  }
```