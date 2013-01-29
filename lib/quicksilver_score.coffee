###
 ** Modified Quicksilver so that that it doesn't extends the `String` object's prototype.

 qs_score - Quicksilver Score

 A port of the Quicksilver string ranking algorithm

 score("hello world", "axl") //=> 0.0
 score("hello world", "ow") //=> 0.6
 score("hello world", "hello world") //=> 1.0

 Tested in Firefox 2 and Safari 3

 The Quicksilver code is available here
 http://code.google.com/p/blacktree-alchemy/
 http://blacktree-alchemy.googlecode.com/svn/trunk/Crucible/Code/NSString+BLTRRanking.m

 The MIT License

 Copyright (c) 2008 Lachie Cox

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
###
class ScoredString extends String
ScoredString::score = (abbreviation, offset) ->
  offset = offset or 0 # TODO: I think this is unused... remove
  return 0.9  if abbreviation.length is 0
  return 0.0  if abbreviation.length > @.length
  i = abbreviation.length

  while i > 0
    sub_abbreviation = abbreviation.substring(0, i)
    index = @.indexOf(sub_abbreviation)
    continue  if index < 0
    continue  if index + abbreviation.length > @.length + offset
    next_string = @.substring(index + sub_abbreviation.length)
    next_abbreviation = null
    if i >= abbreviation.length
      next_abbreviation = ""
    else
      next_abbreviation = abbreviation.substring(i)
    remaining_score = new ScoredString(next_string).score(next_abbreviation, offset + index)
    if remaining_score > 0
      score = @.length - next_string.length
      unless index is 0
        j = 0
        c = @.charCodeAt(index - 1)
        if c is 32 or c is 9
          j = (index - 2)

          while j >= 0
            c = @.charCodeAt(j)
            score -= ((if (c is 32 or c is 9) then 1 else 0.15))
            j--
        else
          score -= index
      score += remaining_score * next_string.length
      score /= @.length
      return score
    i--
  0.0

module.exports = ScoredString