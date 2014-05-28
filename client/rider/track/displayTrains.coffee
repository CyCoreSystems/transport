Template.displayTrains.cutify = ->
	line = Session.get 'trackLine'
	return line

Template.displayTrains.trains = ->
	line = Session.get 'trackLine'
	return TrainTracks.find { line:line}
