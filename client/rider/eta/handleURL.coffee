Template.handleURL.stationDoc = ->
	stop = Session.get 'etaStop'
	return Stations.findOne({ name: stop})
