@TrainTracks = new Meteor.Collection 'train_tracks'

if Meteor.isServer
	trainsInterval = null
	Meteor.startup ->
		updateTracker()
		trainsInterval = Meteor.setInterval updateTracker,10000

trainIDlist= []

updateTracker = ->
	arrivalDocs = Arrivals.find {next_arr: { $gt: moment().unix() } }
	arrivalDocs.forEach getTrainID
	createDocument id for id in trainIDlist
	trainIDlist = []

# gets the train IDs, no repeats, so we can create an object for both and upload to own Collection
getTrainID = (doc) ->
	train_id = doc["train_id"]
	if train_id not in trainIDlist
		trainIDlist.push train_id

filterTrainTracks = (id) ->
	tt_collection = TrainTracks.findOne {train_id:id}
	if not tt_collection
		createNewTT(id)
		


createNewTT = (id) ->
	arrival_collection = Arrivals.find({train_id:id},{sort:{next_arr:1}}).fetch()
	i = 0
	stopObArr = []
	while i<arrival_collection.length
		arrival = arrival_collection[j]
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
