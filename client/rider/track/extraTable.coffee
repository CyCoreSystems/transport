Meteor.startup ->
	Session.setDefault 'ttID',null

Template.extraTable.ttIDSet = ->
	if Session.equals 'ttID',null
		return false
	return true

Template.extraTable.getID = ->
	return Session.get 'ttID'

Template.extraTable.trainToday = ->
	tID = Session.get 'ttID'
	tDoc = TrainTracks.findOne({train_id:tID})
	if tDoc isnt undefined
		today = moment().format 'e'
		validObjects = _.where tDoc.stopObjects, {dayRunning:today}
		return validObjects
	return null

Template.extraTable.trainYesterday = ->
	tID = Session.get 'ttID'
	tDoc = TrainTracks.findOne({train_id:tID})
	if tDoc isnt undefined
		today = moment().format 'e'
		switch today
			when '0' then yesterday = '6'
			else yesterday = parseInt(today)-1
		yesterday.toString
		validObjects = _.where tDoc.stopObjects, {dayRunning:yesterday}
		return validObjects
	return null

Template.extraTable.trainTwoDaysAgo = ->
	tID = Session.get 'ttID'
	tDoc = TrainTracks.findOne({train_id:tID})
	if tDoc isnt undefined
		today = moment().format 'e'
		switch today
			when '0' then dayBefore = '5'
			when '1' then dayBefore = '6'
			else dayBefore = parseInt(today)-1
		dayBefore.toString
		validObjects = _.where tDoc.stopObjects, {dayRunning:dayBefore}
		return validObjects
	return null
