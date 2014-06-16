@MergedTimes = new Meteor.Collection 'merged_times'

if Meteor.isServer
	trainsInterval = null
	Meteor.startup ->
		updateList()
		trainsInterval = Meteor.setInterval updateList,10000

updateList = ->
	console.log 'loading schedule data'
	loadScheduleData doc for doc in Schedule.find().fetch()
	console.log 'loading realtime data'
	loadRealData doc for doc in Arrivals.find().fetch()
	MergedTimes.remove {
		next_arr: { $lt: moment().unix() }
	}

loadScheduleData = (doc) ->
	event_time = moment().unix()
	waiting_seconds = moment(doc.arrival_time,'H:mm:ss').unix()-event_time
	next_arr = moment(doc.arrival_time, 'H:mm:ss').unix()
	if next_arr > moment().unix() and next_arr < moment().unix() + 1200
		MergedTimes.update {
			dataSource:'schedule'
			schedule_time:doc.arrival_time
			line:doc.line
			direction:doc.direction
			station:doc.stop_name
			service_id:doc.service_id
		},{
			$set:
				next_arr:next_arr
				station:doc.stop_name
				line:doc.line
				direction:doc.direction
				schedule_time:doc.arrival_time
				waiting_seconds:waiting_seconds
				event_time:event_time
				service_id:doc.service_id
				dataSource:"schedule"
		},{ upsert:true }

loadRealData = (doc) ->
	if doc.next_arr > moment().unix()
		MergedTimes.update {
			station:doc.station
			train_id:doc.train_id
		},{
			$set:
				next_arr:doc.next_arr
				train_id:doc.train_id
				station:doc.station
				line:doc.line
				direction:doc.direction
				waiting_seconds:doc.waiting_seconds
				event_time:doc.event_time
				dataSource:"realtime"
		},{ upsert:true }
