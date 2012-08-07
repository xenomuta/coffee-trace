#
# Coffee-Trace: Simpler and better way to match corresponding javascript 
# line when debuging CoffeeScript.
#
# just require this in your code and be happy...
#

process.on 'uncaughtException', (err) ->
  margin = 3  # Shown lines before and after trace line.
  coffee_trace = (stack = err.stack.split("\n"))[1].match(/^ +at[^\/]+((?:\w+:\/\/)?[^:]+):(\d+):(\d+)/) or []
  filename = coffee_trace[1]
  line_num = Number(coffee_trace[2])
  line_col = Number(coffee_trace[3])
  if /\.coffee$/.test filename
    # A very pleasent cup of coffee crash!!!
    console.error "\n\x1b[01;37m   _..,----,.._"
    console.error " .-;'-.,____,.-';"
    console.error "(( |            |"
    console.error " `))            ;"
    console.error "  ` \\          /"
    console.error " .-' `,.____.,' '-."
    console.error "(     '------'     )"
    console.error " `-=..________..--' \x1b[0;33m. O o\n"
    console.error "\x1b[1;31;43mCoffee-Trace:\x1b[0m\x1b[1;37;40m #{filename}\x1b[33m:\x1b[32m#{line_num}\x1b[33m:\x1b[32m#{line_col}\n"
    console.error " \x1b[41;37m", stack[0], "\x1b[0m"
    console.error "\x1b[0m  ..."
    lines = require('coffee-script').compile(require('fs').readFileSync(filename).toString('utf8')).split(/\n/)
    lines.map (_,l) ->
      l += 1
      if (line_num >= l - margin) and (line_num <= l + margin)
        { line: l, source: _.replace(/(\r\n|\n)/, '') }
    .forEach (l) ->
      if l?
        _line_num = new Array(line_num.toString().length - l.line.toString().length).join(' ') + l.line
        if l.line is line_num
          console.error "\x1b[#{line_num.toString().length + line_col + 5}C\x1b[1A\x1b[1;31m▼"
          console.error " \x1b[1;31m✘\x1b[36m " + _line_num + ": \x1b[1;37m" + l.source
        else
          console.error " \x1b[0;36m  " + _line_num + ": \x1b[1;30m" + l.source
    console.error "\x1b[0m  ..."
    
  console.error stack.join("\n")
  console.error()
  process.exit()
