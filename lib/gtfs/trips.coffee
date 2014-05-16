@Trips = new Meteor.Collection 'trips'

if Meteor.isServer
  # Remove all on start (this is a poor-man's data refresh)
  Trips.remove {}

  # Hard-code for now
  trips = [
    {
      id: 4009837
      route_id: 3993294
      service_id: 2
      trip_headsign: 'Route 1- Coronet Way'
      direction_id: 0
      block_id: 225450
      shape_id: 86068
    }
  ]
  _.each trips,(trip)->
    Trips.insert trip
    return
  return

  # TODO change the url for the HTTP.get call
  # Re-add all data from service
  res = HTTP.get 'http://api.navdash.com/trips'
  if res.statusCode isnt 200
    throw new Meteor.Error(500, 'Failed to fetch trips list')
  if not _.isArray res.data
    throw new Meteor.Error(500, 'Bad data received for trips list')
  _.each res.data,(trip)->
    Trips.insert trip
    return
  
