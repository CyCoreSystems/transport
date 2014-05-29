liveClock = new Deps.Dependency

Meteor.startup ->
	setInterval ->
		liveClock.changed()

Template.displayTrains.getID = (doc) ->
	return doc["train_id"]

Template.displayTrains.getDirection = (doc)->
	dir = doc["direction"]
	switch dir
		when 'S' then return 'South'
		when 'N' then return 'North'
		when 'E' then return 'East'
		when 'W' then return 'West'

Template.displayTrains.trains = ->
	line = Session.get 'trackLine'
	return TrainTracks.find { line:line}

Template.displayTrains.getStop1 = (doc)->
	return doc["stopArray"][0]

Template.displayTrains.getTime1 = (doc) ->
	liveClock.depend()
	event_timeArray = doc["event_timeArray"]
	timeArray = doc["timeArray"]
	offset = moment().unix() - event_timeArray[0]
	liveETA = timeArray[0] - offset
	duration = moment.duration(liveETA,"seconds")
	if liveETA > 299
		return "#{Math.floor(duration.asMinutes())} min"
	# For short times, display seconds
	secs = duration.seconds()
	if secs < 0
		return "now"
	if secs < 60
		if duration.minutes()<1
			return "#{secs}s"
	return "#{duration.minutes()}m #{secs}s"

Template.displayTrains.getStop2 = (doc) ->
	stopArray = doc["stopArray"]
	if stopArray.length <2
		return "No more stops"
	else
		return stopArray[1]

Template.displayTrains.getTime2 = (doc) ->
	liveClock.depend()
	event_timeArray = doc["event_timeArray"]
	timeArray = doc["timeArray"]
	if timeArray.length > 1
		offset = moment().unix() - event_timeArray[1]
		liveETA = timeArray[1] - offset
		duration = moment.duration(liveETA,"seconds")
		if liveETA > 299
			return "#{Math.floor(duration.asMinutes())} min"
		# For short times, display seconds
		secs = duration.seconds()
		if secs < 0
			return "now"
		if secs < 60
			if duration.minutes()<1
				return "#{secs}s"
		return "#{duration.minutes()}m #{secs}s"
	else
		return ""
