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
		updateTT(id,tt_doc.stopObjects,arrivalObjectArray)

createNewTT = (id,arr_docs,stopObjects) ->
	TrainTracks.insert {
		train_id: id
		stopObjects: stopObjects
		line:arr_docs[0].line
		direction:arr_docs[0].direction
		lastUpdate:moment().unix()
	}

updateTT = (id,ttStopObjects,newStopObjects) ->
	i=0
	newPluck = _.pluck newStopObjects,"station"
	oldPluck = _.pluck ttStopObjects,"station"
	setFlagFalse stationName,id for stationName in _.difference oldPluck,newPluck
	while i<newStopObjects.length
		newStopObject = newStopObjects[i]
		thisObject = _.findWhere ttStopObjects,{station:newStopObject["station"]}
		if thisObject
			TrainTracks.update {
				train_id:id
				"stopObjects.station":newStopObject.station
			},{
				$set:
					"stopObjects.$.event_time":newStopObject.event_time
					"stopObjects.$.time":newStopObject.time
					"stopObjects.$.arrivedFlag":true
					lastUpdate: moment().unix()
			}
		else
			TrainTracks.update {
				train_id:id
			},{
				$push:
					stopObjects:newStopObject
				$set:
					lastUpdate: moment().unix()
			}
		i++

setFlagFalse = (name,id) ->
			TrainTracks.update {
				train_id:id
				"stopObjects.station":name
			},{
				$set:
					"stopObjects.$.arrivedFlag":false
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
			arrivedFlag:true
		stopObArr.push stopObject
		i++
	return stopObArr
