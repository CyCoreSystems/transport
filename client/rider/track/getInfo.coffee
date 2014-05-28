liveClock = new Deps.Dependency

Meteor.startup ->
	setInterval ->
		liveClock.changed()

Template.getInfo.liveData = ->
	liveClock.depend()
	timeArray = @timeArray
	stopArray = @stopArray
	train_id = @train_id
	dir = @direction
	direction = ''
	switch dir
		when 'S' then direction = 'South'
		when 'N' then direction = 'North'
		when 'E' then direction = 'East'
		when 'W' then direction = 'West'
	if stopArray.length >= 2
		offset1 = moment().unix() - @event_timeArray[0]
		offset2 = moment().unix() - @event_timeArray[1]
		liveETA1 = @timeArray[0] - offset1
		liveETA2 = @timeArray[1] - offset2
		duration1 = moment.duration(liveETA1,"seconds")
		duration2 = moment.duration(liveETA2,"seconds")
		if liveETA1 > 299
			return "train "+train_id+" headed "+direction+" to "+@stopArray[0]+", arriving in #{Math.floor(duration1.asMinutes())} m"
		secs1 = duration1.seconds()
		secs2 = duration2.seconds()
		if secs1 <0
			return "train "+train_id+" headed "+direction+" to "+@stopArray[0]+", arriving NOW"
		if secs1 <60
			return "train "+train_id+" headed "+direction+" to "+@stopArray[0]+", arriving in #{secs1}s"
		return "train "+train_id+" headed "+direction+" to "+@stopArray[0]+", arriving in #{duration1.minutes()}m #{secs1}s"
	else
		offset = moment().unix() - @event_timeArray[0]
		liveETA = @timeArray[0] - offset
		duration = moment.duration(liveETA,"seconds")
		if liveETA > 299
			return "#{Math.floor(duration.asMinutes())} min"
		# For short times, display seconds
		secs = duration.seconds()
		if secs < 0
			return "now"
		if secs < 60
			return "#{secs}s"
		return "#{duration.minutes()}m #{secs}s"
