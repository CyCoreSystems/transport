@Arrivals = new Meteor.Collection 'arrivals'

if Meteor.isServer
  trainsInterval = null
  Meteor.startup ->
    updateArrivals()
    trainsInterval = Meteor.setInterval updateArrivals,10000

updateArrivals = ->
  console.log "Updating arrivals"
  res = HTTP.get "http://developer.itsmarta.com/RealtimeTrain/RestServiceNextTrain/GetRealtimeArrivals?apikey=#{share.api_key_MARTA}"
  if res.statusCode isnt 200
    return console.error "Failed to get train data",res
  if not _.isArray res.data
    return console.error "Got invalid train data",res
  console.log "Update contains #{res.data.length} arrivals"
  _.each res.data,(i)->
    event_time = moment(i.EVENT_TIME).unix()
    next_arr = moment(i.NEXT_ARR,'hh:mm:ss A').unix()
    console.log("Next arrival time processed as:",next_arr)
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
  #Arrivals.remove {
  #  next_arr: { $lt: moment().unix() }
  #}
