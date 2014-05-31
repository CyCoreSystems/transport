@TrainTracks = new Meteor.Collection 'train_tracks'

if Meteor.isServer
	trainsInterval = null
	Meteor.startup ->
		updateTracker()
		trainsInterval = Meteor.setInterval updateTracker,10000

updateTracker = ->
	filterTrainTracks id for id in _.uniq(_.pluck(Arrivals.find().fetch(),'train_id'))

filterTrainTracks = (id) ->
	tt_doc = TrainTracks.findOne {train_id:id}
	if not tt_doc
		createNewTT(id)
	else
		updateTT(id)

		# If there's no document in TrainTracker, we insert a new one. Easy operation.
		# The update part is slightly mas dificil.
createNewTT = (id) ->
	arrival_collection = Arrivals.find({train_id:id},{sort:{next_arr:1}}).fetch()
	i = 0
	stopObArr = []
	while i<arrival_collection.length
		arrival = arrival_collection[i]
		stopObject =
			time:arrival.waiting_seconds
			station:arrival.station
			event_time:arrival.event_time
		stopObArr.push stopObject
		i++
	TrainTracks.insert {
		train_id: id
		stopObjects: stopObArr
		line:arrival_collection[0].line
		direction:arrival_collection[0].direction
		lastUpdate:moment().unix()
		next_stop:0
	}

#TODO
updateTT = (id) ->
	console.log 'TODO'
###
