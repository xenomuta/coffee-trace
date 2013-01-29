require("../.")

[1..100].forEach (i) ->
  setTimeout (-> console.log(i/tt)), Math.random() * 100
