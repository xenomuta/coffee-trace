# Coffee-Trace
_Makes debugging coffee-script easier by displaying corresponding lines of code in the stack-trace with style_

![Coffee-Trace](https://github.com/xenomuta/coffee-trace/raw/master/img/coffee-trace.png "Coffee-Trace")

### About Coffee-Trace
Coffee-Trace makes debugging coffeescript code easier by attempting to point corresponding coffeescript code and line numbers and styling the stacktrace a little bit.

**WARNING**: This is obviously for aiding development needs and by no means intended for production use. It is also, by far, my ugliest piece of code. You've been warned.

### Install and Usage
Unleash your inner masochist and enjoy `uncaughtException` and stack-traces, just by installing with:

  `npm install coffee-trace`

and then

```coffeescript
# Require it at the very beginning of your code
require('coffee-trace')
```

### Example
Running this..

```coffeescript
require('coffee-trace')

test = ->
  people =
    john:
      first_name: 'john'
      last_name: 'doe'
    mary:
      first_name: 'mary'
      last_name: 'jane'

  console.log("Welcome", people[p].first_name, people[p].last_name, "!!!") for p in ['john', 'mary', 'josh']

process.nextTick test
```

will result in this:
![Coffee-Trace](https://github.com/xenomuta/coffee-trace/raw/master/img/example.png "Coffee-Trace example")

### Why?
If you love Coffee-Script and Node.js, you will provably also be frustrated by the challenges of quickly finding and debugging the coffee-script line corresponding to the one pointed out by the stack-trace.

I've been searching a cleaner solution myself, and have found some very useful [links](http://www.adaltas.com/blog/2012/02/15/coffeescript-print-debug-line/ "Coffee script, how do I debug that damn js line?") and [discussions](https://github.com/jashkenas/coffee-script/issues/558 "links and discussions"), but am yet unsatisfied. So, while [SourceMaps](http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/ "SourceMaps") implementation in Coffee-Script is a reality, this is the least I can do.

### ToDo ( Utopic Future High Hopes)
* Beautify and comment code
* Async API for code sandboxing
* Returning a decent stack trace object (with coffee file, line and all).
* A more complete testing
