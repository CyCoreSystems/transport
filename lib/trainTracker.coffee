@TrainTracks = new Meteor.Collection 'train_tracks'

# when used in a variable, 'tt' means traintracker, some instance of the collection.

if Meteor.isServer
	trainsInterval = null
	Meteor.startup ->
		updateTracker()
		trainsInterval = Meteor.setInterval updateTracker,10000

updateTracker = ->
	filterTrainTracks id for id in _.uniq(_.pluck(Arrivals.find().fetch(),'train_id'))

filterTrainTracks = (id) ->
	tt_doc = TrainTracks.findOne {train_id:id}
	arr_docs = Arrivals.find({train_id:id},{sort:{next_arr:1}}).fetch()
	arrivalObjectArray = getArrivalStopObjects arr_docs
	if not tt_doc
		createNewTT(id,arr_docs,arrivalObjectArray)
	else
		updateTT(tt_doc,arr_docs,arrivalObjectArray)

createNewTT = (id,arr_docs,stopObjects) ->
	console.log 'hi'
	i=0
	indexObj = {}
	while i<arr_docs.length
		arrival = arr_docs[i]
		indexObj[arrival.station]=i
		i++
	indexObj["last"]=i
	TrainTracks.insert {
		indexMap:indexObj
		train_id: id
		stopObjects: stopObjects
		line:arr_docs[0].line
		direction:arr_docs[0].direction
		lastUpdate:moment().unix()
		next_stop:0
	}

#TODO
updateTT = (tt_doc,arr_docs,stopObjects) ->
	console.log 'TODO'

getArrivalStopObjects = (arr_docs) ->
	i=0
	stopObArr = []
	while i<arr_docs.length
		arrival = arr_docs[i]
		stopObject =
			time:arrival.waiting_seconds
			station:arrival.station
			event_time:arrival.event_time
		stopObArr.push stopObject
		i++
	return stopObArr
