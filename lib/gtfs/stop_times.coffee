@StopTimes = new Meteor.Collection 'stop_times'

if Meteor.isServer
  # Remove all on start (this is a poor-man's data refresh)
  StopTimes.remove {}

  # Hard-code for now
  stoptimes = [
    {
      trip_id: 3993294
      arrival_time: '07:35:00'
      departure_time: '07:35:00'
      stop_id: 904262
      stop_sequence: 1
    }
  ]
  _.each stoptimes,(time)->
    StopTimes.insert time
    return
  return

  # connection refused at this URL
  # Re-add all data from service
  res = HTTP.get 'http://localhost:1337/api/getstoptime'
  if res.statusCode isnt 200
    throw new Meteor.Error(500, 'Failed to fetch stoptimes list')
  if not _.isArray res.data
    throw new Meteor.Error(500, 'Bad data received for stoptimes list')
  _.each res.data,(time)->
    StopTimes.insert time
    return
  
