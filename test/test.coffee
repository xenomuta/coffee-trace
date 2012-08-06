require '../'

test = ->
  people =
    john:
      first_name: 'john'
      last_name: 'doe'
    mary:
      first_name: 'mary'
      last_name: 'jane'
  
  console.log("Welcome", people[p].first_name, people[p].last_name, "!!!") for p in ['john', 'mary', 'josh']

process.nextTick test
