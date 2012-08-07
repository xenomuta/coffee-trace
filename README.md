Coffee-Trace
============
_makes debugging coffee-script easier by displaying corresponding lines of code in the stack-trace with style_

![Coffee-Trace](https://github.com/xenomuta/coffee-trace/raw/master/img/coffee-trace.png "Coffee-Trace")

### About Coffee-Trace
If you love Coffee-Script and Node.js as much as me, you will provably also be frustrated by the challenges of quickly finding and debugging the corresponding javascript line on the stack-trace. I wrote Coffee-Trace in an attempt to make this task easier.
 
I've been searching myself for a solution, and have found some very useful [links](http://www.adaltas.com/blog/2012/02/15/coffeescript-print-debug-line/ "Coffee script, how do I debug that damn js line?") and [discussions](https://github.com/jashkenas/coffee-script/issues/558 "links and discussions"), but am yet unsatisfied. So, while [SourceMaps](http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/ "SourceMaps") implementation in Coffee-Script is a reality, this is the least I can do.

### Install Usage

Install with:
  `npm install coffee-trace`

Become a masochist by enjoying uncaught exceptions and crashes. Just `require()` it at the very beginning of your code...

### Utopic Future (High Hopes)

I have this crazy idea that someday I'll have some time to make this show the actual coffee-script line corresponding to the trace.
That's right boyz, full source mapping.
