@TrainTracks = new Meteor.Collection 'train_tracks'

if Meteor.isServer
	trainsInterval = null
	Meteor.startup ->
		updateTracker()
		trainsInterval = Meteor.setInterval updateTracker,10000

trainIDlist= []

updateTracker = ->
	TrainTracks.remove {}
	arrivalDocs = Arrivals.find {next_arr: { $gt: moment().unix() } }
	arrivalDocs.forEach getTrainID
	createDocument id for id in trainIDlist
	trainIDlist = []

# gets the train IDs, no repeats, so we can create an object for both and upload to own Collection
getTrainID = (doc) ->
	train_id = doc["train_id"]
	if train_id not in trainIDlist
		trainIDlist.push train_id

createDocument = (id) ->
	collection = Arrivals.find { train_id:id},{sort:{next_arr:1}}
	collection = collection.fetch()
	i=collection.length
	j=0
	timeArray = []
	stopArray = []
	event_timeArray = []
	while j<i
		timeArray.push collection[j]["waiting_seconds"]
		stopArray.push collection[j]["station"]
		event_timeArray.push collection[j]["event_time"]
		j++
	line = collection[0]["line"]
	direction = collection[0]["direction"]
	TrainTracks.update {
		train_id: id
	},{
		$set:
			event_timeArray: event_timeArray
			train_id: id
			timeArray: timeArray
			stopArray: stopArray
			direction: direction
			line: line
	},{ upsert: true }
