liveClock = new Deps.Dependency

Meteor.startup ->
	setInterval ->
		liveClock.changed()

Template.displayTrains.events {
	'click td[trainid=broadID]' : (e,template) ->
		if Session.equals 'ttID',this.train_id
			Session.set 'ttID',null
		else
			Session.set 'ttID',this.train_id
}

Template.displayTrains.getDirection = (doc)->
	dir = doc["direction"]
	switch dir
		when 'S' then return 'South'
		when 'N' then return 'North'
		when 'E' then return 'East'
		when 'W' then return 'West'

Template.displayTrains.trains = ->
	line = Session.get 'trackLine'
	return TrainTracks.find { isRunning:true,line:line}

Template.displayTrains.getStop = (doc,index)->
	i = getFirstIndex _.pluck(doc.stopObjects,'arrivedFlag')
	if index is 0
		return _.pluck(doc.stopObjects,'station')[i]
	else if isSecondStop _.pluck(doc.stopObjects,'arrivedFlag')
		return _.pluck(doc.stopObjects,'station')[i+1]
	else
		return "no more stops"

Template.displayTrains.getTime = (doc, index) ->
	liveClock.depend()
	event_timeArray = _.pluck doc.stopObjects,'event_time'
	timeArray = _.pluck doc.stopObjects,'time'
	i = getFirstIndex _.pluck(doc.stopObjects,'arrivedFlag')
	if index is 0
		offset = moment().unix() - event_timeArray[i]
		liveETA = timeArray[i] - offset
	else
		offset = moment().unix() - event_timeArray[i+1]
		liveETA = timeArray[i+1] - offset
	if isSecondStop _.pluck(doc.stopObjects,'arrivedFlag') or index is 0
		duration = moment.duration(liveETA,"seconds")
		if liveETA > 299
			return "#{Math.floor(duration.asMinutes())} min"
		# For short times, display seconds
		secs = duration.seconds()
		if secs <0 and duration.minutes()<1
			if index isnt 0
				return ""
			return "now"
		if secs < 60
			if duration.minutes()<1
				return "#{secs}s"
		return "#{duration.minutes()}m #{secs}s"
	return ""

getFirstIndex = (flagArray) ->
	i=0
	while i<flagArray.length
		if flagArray[i] is false
			return i
		i++

isSecondStop = (flagArray) ->
	i=0
	count = 0
	while i<flagArray.length
		if flagArray[i] is false
			count++
		i++
	return count > 1
