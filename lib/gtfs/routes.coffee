@Routes = new Meteor.Collection 'routes'

if Meteor.isServer
  # Remove all routes on start (this is a poor-man's data refresh)
  Routes.remove {}

  # Hard-code the routes, for now
  routes = [
    {
      id: 8484
      short_name: 'Blue'
      name_long:'East/West Line'
      desc: ''
      type: 1
      url: ''
      color: '00FFFF'
      text_color: ''
    }
    {
      id: 8617
      short_name: 'Gold'
      name_long: 'Northeast Doraville Line'
      desc: ''
      type: 1
      url: ''
      color: 'FFFF00'
      text_color: ''
    }
    {
      id: 8487
      short_name: 'Green'
      name_long: 'Proctor Creek Line'
      desc: ''
      type: 1
      url: ''
      color: '00FF00'
      text_color: ''
    }
    {
      id: 8618
      short_name: 'Red'
      name_long: 'North Springs Line'
      desc: ''
      type: 1
      url: ''
      color: 'F0CAA6'
      text_color: ''
    }
  ]
  _.each routes,(route)->
    Routes.insert route
    return
  # Return after loading fake data
  return

  # change get URL
  # Re-add all stops from service
  res = HTTP.get 'http://api.navdash.com/routes'
  if res.statusCode isnt 200
    throw new Meteor.Error(500, 'Failed to fetch stops list')
  if not _.isArray res.data
    throw new Meteor.Error(500, 'Bad data received for stops list')
  _.each res.data,(stop)->
    Routes.insert stop
    return
  
