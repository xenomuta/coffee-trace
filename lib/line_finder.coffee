fs = require 'fs'
coffee = require 'coffee-script'

module.exports = (file, trace_lines=[]) ->
  # Indentator used
  indent = undefined
  # Read all source code lines
  source = fs.readFileSync(file).toString('utf8').split(/\n/)
  # Get exception line
  crash_line = trace_lines.map((l)->l.source if l.crash_line).filter((l)->l)[0]

  # Find indentator being used
  for line in source
    break if /^[ \t]/.test(line) and (indent = line.match(/^(\t| +)/)[1])

  # Compile blocks from level to level until compiled lines match traced_lines
  last_index = 0
  found = 0
  matched_block = []
  for indent_level in [1..255]
    indent_rx = new RegExp "^#{indent}{#{indent_level}}"
    for line, i in source
      line_num = i
      block = []
      continue if i < last_index      # Carry on after last block
      if indent_rx.test(line) or line.replace(/[ \t]+/g, '').length is 0
        block.push(source[i-1]) if i > 0
        while (line = source[i]) and (indent_rx.test(line) or line.replace(/[ \t]+/g, '').length is 0)
          i++
          block.push line
        last_index = i
        try
          compiled = coffee.compile block.join("\n")
          total_match = 0
          for trace_line in trace_lines
            if compiled.indexOf(trace_line.source) > -1
              ++total_match
            else
              --total_match if total_match > 0
          matched_block = block.map((l) -> { line: line_num++, source: l }) if (found = total_match is trace_lines.length)
        catch e
          compiled = "" 

  # Try to match javascript crash line with coffeescript line number
  if matched_block
    # console.log "\x1b[01;37;#{Math.round(Math.random()*5)+41}m",matched_block,"\x1b[0m\n"
    portions = crash_line.split(/[,\{\}\(\)\t ]+/).filter (p) -> p and p.length
    match_line = 0
    score = -999999
    
    for l in matched_block
      num = l.line
      line = l.source
      total_match = 0
      for p in portions
        if line.indexOf(p) > -1
          while line.indexOf(p) > -1
            total_match++
            line = line.replace p, ''
        else
           total_match--
      if total_match > score
        score = total_match
        match_line = num

    return match_line