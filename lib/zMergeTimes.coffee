@Schedule = new Meteor.Collection 'schedule'
@MergedTimes = new Meteor.Collection 'merged_times'

if Meteor.isServer
	trainsInterval = null
	Meteor.startup ->
		updateList()
		trainsInterval = Meteor.setInterval updateList,10000

updateList = ->
	console.log 'loading schedule data'
	loadScheduleData doc for doc in Schedule.find().fetch()
	console.log (Schedule.find().count()+' loaded')
	console.log 'loading realtime data'
	loadRealData doc for doc in Arrivals.find().fetch()
	console.log (Arrivals.find().count()+' loaded')
	MergedTimes.remove {
		next_arr: { $lt: moment().unix() }
	}

loadScheduleData = (doc) ->
	event_time = moment().unix()
	waiting_seconds = moment(doc.arrival_time,'H:mm:ss').unix()-event_time
	schedule_time = doc.arrival_time
	line = doc.line
	station = doc.stop_name
	direction = doc.direction
	service_id = doc.service_id
	next_arr = moment(schedule_time, 'H:mm:ss').unix()
	MergedTimes.update {
		station:station
		line:line
		schedule_time:schedule_time
		direction:direction
		service_id:service_id
	},{
		$set:
			next_arr:next_arr
			station:station
			line:line
			direction:direction
			schedule_time:schedule_time
			waiting_seconds:waiting_seconds
			event_time:event_time
			service_id:service_id
			dataSource:"schedule"
	},{ upsert:true }

loadRealData = (doc) ->
	train_id = doc.train_id
	station = doc.station
	line = doc.line
	direction = doc.direction
	waiting_seconds = doc.waiting_seconds
	event_time = doc.event_time
	next_arr = doc.next_arr
	MergedTimes.update {
		station:station
		train_id:train_id
	},{
		$set:
			next_arr:next_arr
			train_id:train_id
			station:station
			line:line
			direction:direction
			waiting_seconds:waiting_seconds
			event_time:event_time
			dataSource:"realtime"
	},{ upsert:true }
