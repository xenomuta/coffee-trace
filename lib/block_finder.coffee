fs = require("fs")
coffee = require("coffee-script")
{source_line_mappings} = require("./cs_js_source_mapping")
ScoredString = require("./quicksilver_score")

module.exports = (file, trace_lines=[]) ->
  # Read coffee-script source code from file
  source = fs.readFileSync(file).toString()

  # Map lines - Taken from @showell's https://github.com/showell/CoffeeScriptLineMatcher
  cs_lines = source.split '\n'
  js_lines = coffee.compile(source).split '\n'  
  mapping = source_line_mappings cs_lines, js_lines

  # Get exception line
  {line, source} = trace_lines.map((l)->l if l.crash_line).filter((l)->l)[0]

  # Return matching line, matching block or 0
  s_index = 0
  d_index = 0

  # Find matching block and try to find matching line too
  for match, idx in mapping
    # Found block, now try lines...
    if line > d_index and line <= d_index + match[1]
      js_crash_line = source.replace(/\W/g, '')
      block = {lines: cs_lines.slice(s_index, s_index + match[0]), start: s_index + 1, end: s_index + match[0] + 1, crash_line: '?' }
      res = { score: 0, line: 0 }

      # Make a fuzzy compare on javascript crash line and each coffee-script line in block
      for cline, idx2 in block.lines
        score = new ScoredString(js_crash_line).score cline.replace(/\W/g, ''), 0
        if score > res.score
          res.score = score
          res.line = idx2 - 1
      # Pick the highest scoring line match as crash line
      block.crash_line = if res.line > 0 then res.line + s_index else undefined
      return block
    s_index += match[0]
    d_index += match[1]

  # ...otherwise, return same old sad and boring null
  return null