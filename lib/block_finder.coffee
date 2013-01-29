fs = require("fs")
coffee = require("coffee-script")
{source_line_mappings} = require("./cs_js_source_mapping")
ScoredString = require("./quicksilver_score")

module.exports = (file, trace_lines=[]) ->
  # Read coffee-script source code from file
  source = fs.readFileSync(file).toString('utf8')

  # Map lines - Taken from @showell's https://github.com/showell/CoffeeScriptLineMatcher
  cs_lines = source.split '\n'
  js_lines = coffee.compile(source).split '\n'  
  mapping = source_line_mappings cs_lines, js_lines

  # Get exception line
  {line, source} = trace_lines.map((l)->l if l.crash_line).filter((l)->l)[0]
  js_crash_line = source.replace(/\W+/g, ' ')

  # Find matching block and try to find matching line as well
  [s_start, d_start] = [0, 0]
  for match in mapping
    [s_end, d_end] = match
    if [d_start...d_end].indexOf(line) > -1
      block = {lines: cs_lines.slice(s_start, s_end), start: s_start, end: s_end }
      # Make a compare on javascript crash line and each coffee-script line in block
      res = { score: 0, line: 0 }
      for cline, idx2 in block.lines
        score = 0
        for word in cline.replace(/\W+/g, ' ').split ' '
          ++score if js_crash_line.indexOf(word) > -1
        # Set the strongest matching line as possible match line
        if score > res.score
          res.score = score
          res.line = idx2 + 1
      # Pick the highest scoring line match as crash line
      block.crash_line = if res.line > 0 then res.line + s_start else undefined
      return block
    [s_start, d_start] = [s_end, d_end]
  return null


  # ...otherwise, return same old sad and boring null
  return null