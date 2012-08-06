#
# Coffee-Trace: Simpler and better way to match corresponding javascript 
# line when debuging CoffeeScript.
#
# just require this in your code and be happy...
#

process.on 'uncaughtException', (err) ->
  margin = 3  # Shown lines before and after trace line.
  coffee_trace = err.stack.split("\n")[1].match(/^    at ((?:\w+:\/\/)?[^:]+):(\d+):(\d+)/) or []
  filename = coffee_trace[1]
  line_num = Number(coffee_trace[2])
  line_col = Number(coffee_trace[3])
  if /\.coffee$/.test filename
    console.error "\n\x1b[01;36mCoffee-Trace: \x1b[37m#{filename}:#{line_num}:#{line_col}\x1b[0m\n  ...\n"
    lines = require('coffee-script').compile(require('fs').readFileSync(filename).toString('utf8')).split(/\n/)
    lines.map (_,l) ->
      l += 1
      if (line_num >= l - margin) and (line_num <= l + margin)
        { line: l, source: _.replace(/(\r\n|\n)/, '') }
    .forEach (l) ->
      if l?
        console.error " \x1b[01;#{if l.line is line_num then "33" else "30"}m#{if l.line is line_num then "\x1b[31m✘\x1b[37m " else "  "}" + new Array(line_num.toString().length - l.line.toString().length).join(' ') + l.line + ': ' + l.source
    console.error "\x1b[0m  ..."
    
  console.error err.stack
  console.error()
  process.exit()
