#
# Coffee-Trace: Simpler and better way to match corresponding javascript 
# line when debuging CoffeeScript.
#
# just require this in your code and be happy...
#
draw_coffee_cup = ->
  console.error "\n\x1b[0;33m   ( ("
  console.error "    ) )"
  console.error "  ________"
  console.error " |        |]"
  console.error "  \\      /"
  console.error "   `----'  ❛●•・\x1b[0m"
  

module.exports = coffee_trace = (options={ascii_art:true})->
  process.on 'uncaughtException', (err) ->
    margin = 3  # Shown lines before and after trace line.
    coffee_trace = (stack = err.stack.split("\n"))[1].match(/^ +at[^\/]+((?:\w+:\/\/)?[^:]+):(\d+):(\d+)/) or []
    filename = coffee_trace[1]
    line_num = Number(coffee_trace[2])
    line_col = Number(coffee_trace[3])
    
    if /\.coffee$/.test filename
      line_finder = require __dirname + '/line_finder'
      coffee_source = require('fs').readFileSync(filename).toString('utf8')
      lines = require('coffee-script').compile(coffee_source).split(/\n/)
      max_line_length = 2      
      trace_lines = lines.map (_,l) ->
        l += 1
        if (line_num >= l - margin) and (line_num <= l + margin)
          { line: l, crash_line: l is line_num, source: _.replace(/(\r\n|\n)/, '') }   
      .filter (l) -> l
      
      # Fanfare and trumpets...
      draw_coffee_cup() if options.ascii_art
      console.error "\x1b[1;41;37m ❛●•・Coffee-Trace \x1b[0m"
      
      # If coffee-script crash line found then print source-code
      if (coffee_line = line_finder(filename, trace_lines))?
          console.error "\n\x1b[0;33m CoffeeScript:\x1b[0m\x1b[1;37m #{filename}\x1b[33m:\x1b[32m#{coffee_line}\x1b[0m"

        coffee_lines = coffee_source.split(/\r\n|\n/)
        for i in [(coffee_line - margin)..(coffee_line + margin)]
          continue if i < 1
          line = coffee_lines[i - 1]
          _line_num = new Array((coffee_line + margin).toString().length - i.toString().length + 1).join(' ') + i.toString()
          if i is coffee_line
            console.error " \x1b[1;31m✘\x1b[36m " + _line_num + ": \x1b[1;37m" + line
          else
            console.error " \x1b[0;36m  " + _line_num + ": \x1b[1;30m" + line
            
      console.error "\n\x1b[0;33m Javascript:\x1b[0m\x1b[1;37m #{filename}\x1b[33m:\x1b[32m#{line_num}\x1b[33m:\x1b[32m#{line_col}\x1b[0m"
      trace_lines.forEach (l) ->
        _line_num = new Array(line_num.toString().length - l.line.toString().length).join(' ') + l.line
        if l.line is line_num
          console.error "\x1b[#{line_num.toString().length + line_col + 5}C\x1b[1A\x1b[1;31m⬇"
          console.error " \x1b[1;31m✘\x1b[36m " + _line_num + ": \x1b[1;37m" + l.source
        else
          console.error " \x1b[0;36m  " + _line_num + ": \x1b[1;30m" + l.source
        max_line_length = l.source.length if l.source.length > max_line_length
      
      spaces = new Array(Math.round(max_line_length / 2)).join(" ")
      # console.error "\x1b[0;33m",spaces,"•●•∙Coffee Script ∙•●•∙\x1b[0m"
      # if line_num > 1
      #   console.error "\x1b[0;33m\x1b[#{(margin*2)+3}A",spaces,"•●•∙•●•∙\x1b[#{(margin*2)+3}B\x1b[0m"

  
    console.error "\x1b[0m\n", stack.join("\n")
    console.error()
    process.exit()
  coffee_trace

coffee_trace()
