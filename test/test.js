(function() {
  var test;

  require('../');

  test = function() {
    var p, people, _i, _len, _ref, _results;
    people = {
      john: {
        first_name: 'john',
        last_name: 'doe'
      },
      mary: {
        first_name: 'mary',
        last_name: 'jane'
      }
    };
    _ref = ['john', 'mary', 'josh'];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      p = _ref[_i];
      _results.push(console.log("Welcome", people[p].first_name, people[p].last_name, "!!!"));
    }
    return _results;
  };

  process.nextTick(test);

}).call(this);
