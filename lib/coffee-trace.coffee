#
# Coffee-Trace: Simpler and better way to match corresponding javascript
# line when debuging CoffeeScript.
#
# just require this in your code and be happy...
#
draw_coffee_cup = ->
  console.error """\n\x1b[0;33m   ( (
     `)
  ________・•.
 |        |] ・
  \\      /  ❛
   `----'  ・❛●•・\x1b[0m"""

options =
  ascii_art: true
  compiler: 'coffee-script'
  stack_matcher: /^ +at .+ \((.+):(\d+):(\d+)\)/

setup = (newOptions)->
  options[option] = newOptions[option] for option of options when newOptions[option]?

module.exports = coffee_trace = (newOptions = {})->
  coffee_trace.setup(newOptions)

  process.on 'uncaughtException', (err) ->
    margin = 3  # Shown lines before and after trace line.
    coffee_trace = (stack = err.stack.split("\n"))[1].match(options.stack_matcher) or []
    filename = coffee_trace[1]
    line_num = Number(coffee_trace[2])
    line_col = Number(coffee_trace[3])

    if /\.coffee$/.test filename
      # Match corresponding coffee-script lines' block
      block_finder = require __dirname + '/block_finder'
      coffee_source = require('fs').readFileSync(filename, 'utf8')
      lines = require(options.compiler).compile(coffee_source).split(/\n/)
      max_line_length = 2
      trace_lines = lines.map (_,l) ->
        l += 1
        if (line_num >= l - margin) and (line_num <= l + margin)
          { line: l, crash_line: l is line_num, source: _.replace(/(\r\n|\n)/, '') }
      .filter (l) -> l

      # Fanfare and trumpets...
      draw_coffee_cup() if options.ascii_art
      console.error "\x1b[1;41;37m ❛●•・Coffee-Trace \x1b[0m"

      # If coffee-script crash line or block found then print source-code
      if (block = block_finder(filename, trace_lines))?
        {start,end,lines,crash_line} = block
        if crash_line?
          console.error "\n\x1b[0;33m CoffeeScript:\x1b[0m\x1b[1;37m #{filename}\x1b[33m:\x1b[32m#{crash_line}\x1b[0m"
          coffee_lines = coffee_source.split('\n')
          for i in [(crash_line - margin)..(crash_line + margin)]
            _line_num = new Array((crash_line + margin).toString().length - i.toString().length + 1).join(' ') + i.toString()
            continue if crash_line - margin < 1
            line = coffee_lines[i - 1]
            if i is crash_line
              console.error " \x1b[1;31m✘\x1b[36m #{_line_num}: \x1b[1;37m#{line}"
            else
              console.error " \x1b[0;36m  #{_line_num}: \x1b[1;30m#{line}"
        else
          console.error "\n\x1b[0;33m CoffeeScript:\x1b[0m\x1b[1;37m #{filename}\x1b[0m"
          for line, idx in lines
            i = start + idx
            _line_num = new Array(end.toString().length - i.toString().length + 1).join(' ') + i.toString()
            console.error " \x1b[0;36m  #{_line_num}: \x1b[1;30m#{line}"

      console.error "\n\x1b[0;33m Javascript:\x1b[0m\x1b[1;37m #{filename}\x1b[33m:\x1b[32m#{line_num}\x1b[33m:\x1b[32m#{line_col}\x1b[0m"
      trace_lines.forEach (l) ->
        _line_num = new Array(line_num.toString().length - l.line.toString().length).join(' ') + l.line
        if l.line is line_num
          console.error "\x1b[#{line_num.toString().length + line_col + 5}C\x1b[1A\x1b[1;31m⬇"
          console.error " \x1b[1;31m✘\x1b[36m #{_line_num}: \x1b[1;37m#{l.source}"
        else
          console.error " \x1b[0;36m  #{_line_num}: \x1b[1;30m#{l.source}"
        max_line_length = l.source.length if l.source.length > max_line_length

      spaces = new Array(Math.round(max_line_length / 2)).join(" ")

    stack[1] = stack[1].replace(/\.coffee:/, ".js:")
    console.error "\x1b[0m\n", stack.join("\n")
    console.error()
    process.exit()
  coffee_trace

coffee_trace.setup = setup

coffee_trace()
