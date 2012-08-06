#
# Coffee-Trace: Simpler and better way to match corresponding javascript 
# line when debuging CoffeeScript.
#
# just require this in your code and be happy...
#
process.on 'uncaughtException', (err) ->
  try
    _trace = JSON.parse err.stack.split(/\n/)[1]
    .replace(/^    at [^\/]+(\/[^:]+):(\d+):(\d+).*.*/, '{"file":"$1","line":$2,"pos":$3}')
  
  if _trace? and /.coffee$/.test(_trace.file)
    margin = 3  # shown lines before and after trace line.
    lines = require('fs').readFileSync(_trace.file).toString 'utf8'
    coffee = require 'coffee-script'
    lines = coffee.compile(lines)
    
    console.error "\n\x1b[01;36mCoffee-Trace: \x1b[37m#{_trace.file}:#{_trace.line}:#{_trace.pos}\x1b[0m\n    ...\n"
    
    lines = lines.split(/\n/).map (_,l) ->
      l += 1
      if (_trace.line >= l - margin) and (_trace.line <= l + margin)
        { line: l, source: _.replace(/(\r\n|\n)/, '') }
    .forEach (l) ->
      if l?
        console.error "  \x1b[#{if l.line is _trace.line then "01;33" else "00;38"}m#{if l.line is _trace.line then "=>" else "  "}" + new Array(_trace.line.toString().length - l.line.toString().length).join(' ') + l.line + ': ' + l.source
        
    console.error "\x1b[0m    ..."
    
  console.error err.stack
  console.error()
  process.exit()
