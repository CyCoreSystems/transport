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
	i=0
	indexObj = {}
	while i<arr_docs.length
		arrival = arr_docs[i]
		indexObj[arrival.station]=i
		i++
	indexObj["length"]=i
	TrainTracks.insert {
		indexMap:indexObj
		train_id: id
		stopObjects: stopObjects
		line:arr_docs[0].line
		direction:arr_docs[0].direction
		lastUpdate:moment().unix()
		next_stop:0
	}

updateTT = (tt_doc,arr_docs,new_stopObjects) ->
	tt_stopObjects = tt_doc["stopObjects"]
	tt_indexMap = tt_doc["indexMap"]
	lastIndex = tt_indexMap["length"]
	i=0
	while i<new_stopObjects.length
		new_stopObject = new_stopObjects[i]
		thisIndex = tt_indexMap[new_stopObject["station"]]
		if thisIndex	# If the station exists in the object, update it!
			tt_stopObjects[thisIndex]["event_time"]=new_stopObject["event_time"]
			tt_stopObjects[thisIndex]["time"]=new_stopObject["time"]
		else #if the station doesn't exist, append it to stopObjects, add to indexMap
			tt_stopObjects.push new_stopObject
			tt_indexMap[new_stopObject["station"]]=lastIndex
			lastIndex++
		i++
	next_stop = tt_indexMap[new_stopObjects[0]["station"]]
	tt_indexMap["length"]=lastIndex
	TrainTracks.update {
		train_id:tt_doc.train_id
	},{
		$set:
			indexMap:tt_indexMap
			stopObjects:tt_stopObjects
			next_stop:next_stop
			lastUpdate:moment().unix()
	}

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
