@Arrivals = new Meteor.Collection 'arrivals'
@Schedule = new Meteor.Collection 'schedule'

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
		event_time = moment(i.EVENT_TIME).unix()
		next_arr = moment(i.NEXT_ARR,'hh:mm:ss A').unix()
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
	console.log Schedule.find( { arrival_time: { $gt: moment().unix() }, service_id: '3'} ).fetch()
	currDay= moment().day()
	switch currDay
		when '1','2','3','4','5' then mergeFields scheduleDoc for scheduleDoc in Schedule.find( { arrival_time: { $gt: moment().unix() }, service_id: '5' } ).fetch()
		when '6' then mergeFields scheduleDoc for scheduleDoc in Schedule.find( { arrival_time: { $gt: moment().unix() }, service_id: '3' } ).fetch()
		when '0' then mergeFields scheduleDoc for scheduleDoc in Schedule.find( { arrival_time: { $gt: moment().unix() }, service_id: '4' } ).fetch()
		

mergeFields = (doc) ->
	station = doc["stop_name"]
	console.log station
	arrTime = doc["arrival_time"]
	direction = doc["direction"]
	line = doc["line"]
	waiting_sec = arrTime-moment().unix()
	waiting_min = arrTime-moment().unix()
	arrDoc = Arrivals.find( { station: station })
	if arrDoc.count() is '0'
		console.log station
		Arrivals.update {
			station:station
		},{
			$set:
				next_arr: arrTime
				direction: direction
				line:line
				event_time: moment().unix()
				waiting_seconds: waiting_sec
				waiting_time: waiting_min
		},{ upsert: true }
