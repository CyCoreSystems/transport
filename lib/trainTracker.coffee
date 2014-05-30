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

createDocument = (id) ->
	collection = Arrivals.find({train_id:id},{sort:{next_arr:1}}).fetch()
	i=0
	while i<collection.length
		arrival = collection[j]
		stopObject =
			station:arrival.station
			time:arrival.waiting_seconds
			event_time:arrival.event_time
		dummyObject =
			stopObject:stopObject
			line:arrival.line
			direction:arrival.direction
			lastUpdate:moment().unix()
			thisStation:arrival.next_arr
		updater(dummObject)
		i++

updater = (newOb) ->
