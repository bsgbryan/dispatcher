Overview
========

dispatcher provides a simple way to process websocket messages that define an action.

dispatcher is used by [instrumentor](https://github.com/bsgbryan/instrumentor), allowing you
to wrap dispatched modules in additional behavior.

dispatcher handles requiring modules for you - dispatcher uses the `action` property of your
message as the module name to `require`.

message
-------

The only required property is `action`. The message is passed directly to the required module,
so any other properties make it to the dispatched module.

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

Doing this tells `dispatcher` where you store the modules you're going to dispatching messages to.

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
essentially for free.

Listeners
=========

Any module that has a `send` method that takes the correct arguments can be a listener.

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