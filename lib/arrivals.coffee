@Arrivals = new Meteor.Collection 'arrivals'

if Meteor.isServer
  trainsInterval = null
  Meteor.startup ->
    updateArrivals()
    trainsInterval = Meteor.setInterval updateArrivals,10000

updateArrivals = ->
  res = HTTP.get "http://developer.itsmarta.com/RealtimeTrain/RestServiceNextTrain/GetRealtimeArrivals?apikey=#{share.api_key_MARTA}"
  if res.statusCode isnt 200
    return console.error "Failed to get train data",res
  if not _.isArray res.data
    return console.error "Got invalid train data",res
  _.each res.data,(i)->
    event_time = moment.tz(i.EVENT_TIME,"UTC").unix()
    next_arr = moment.tz(i.NEXT_ARR,'hh:mm:ss A',"UTC").unix()
    console.log("This arrival is at:",next_arr,"compared to now:",moment().unix())
    Arrivals.update {
      train_id: i.TRAIN_ID
      station: i.STATION
    },{
      $set:
        train_id: i.TRAIN_ID
        destination: i.DESTINATION
        direction: i.DIRECTION
        event_time: event_time
        line: i.LINE
        next_arr: next_arr
        station: i.STATION
        waiting_seconds: i.WAITING_SECONDS
        waiting_time: i.WAITING_TIME
    },{ upsert: true }
  # Empty out old data
  Arrivals.remove {
    next_arr: { $lt: moment().unix() }
  }
