Overview
========

dispatcher provides a simple way to process websocket messages that define an action.

dispatcher also supports [instrumentor](https://github.com/bsgbryan/instrumentor), allowing you
to wrap dispatched modules in additional behavior.

dispatcher handles requiring modules for you - dispatcher uses the `action` property of your
message as the module name to `require`.

message
-------

The only required property is `action`. The message is passed directly to the required module,
so any other properties make it to the dispatched module.

How to use
==========

There are two steps to using dispatcher:

Get it
------

```javascript
  var dispatcher = require('dispatcher')
```

Invoke it
---------

```javascript
	dispatcher(message, socket)
```

Since dispatcher only works with modules the expose their functionality via promises it can take
care of sending the response back across the socket.

TODO
====

Break the dependency on websockets by specifying that all dispatchable modules must have a `send`
method. This is what would be used to process promise events.