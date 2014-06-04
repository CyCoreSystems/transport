Meteor.startup ->
	Session.setDefault 'ttID',null

Template.extraTable.ttIDSet = ->
	if Session.equals 'ttID',null
		return false
	return true

Template.extraTable.getID = ->
	return Session.get 'ttID'

Template.extraTable.train = ->
	tID = Session.get 'ttID'
	tDoc = TrainTracks.findOne({train_id:tID})
	console.log tDoc
	if tDoc isnt undefined
		return tDoc["stopObjects"]
	return null
