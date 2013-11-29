exec = require('child_process').exec
assert = require('assert')

describe 'Coffe-Trace', ->
  it 'should show corresponding line number in coffee-script stack trace', ->
    exec "#{__dirname}/../node_modules/coffee-script/bin/coffee #{__dirname}/test2.coffee", (err, stdout, stderr) ->
      assert.ok /test2\.coffee:4$/m.test(stdout)
