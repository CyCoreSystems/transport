###
@Stops = new Meteor.Collection 'stops'
@StopTimes = new Meteor.Collection 'stop_times'
@Trips = new Meteor.Collection 'trips'
@Routes = new Meteor.Collection 'routes'
@Calendar = new Meteor.Collection 'calendar'
@Schedule = new Meteor.Collection 'schedule'

times =[]

if Meteor.isServer
	Meteor.startup ->
		refreshSchedule color for color in ['RED','GOLD','GREEN','BLUE']

# refresh schedule for red, gold, blue, green.
# return all corresponding route names
refreshSchedule = (col) ->
	console.log 'grabbing routes for '+col
	routeCursor = Routes.find {route_short_name:col}
	routeCursor.forEach routeToTrip

# accepting the document from Routes, get collection of trips
# this is all necessary to weed out the bus schedule data.
# we now only have the routes for trains.
routeToTrip = (routeDoc) ->
	console.log 'grabbing trips for route '+routeDoc["route_id"]
	tripCursor = Trips.find {route_id:routeDoc["route_id"]}
	tripCursor.forEach infoFromTrip

#accepting the document from Trips, we can get the stop_times collection.
infoFromTrip = (tripDoc) ->
	timeCursor = StopTimes.find {trip_id:tripDoc["trip_id"]}
	timeCursor.forEach getFullObject

# we can backtrack using the trip_id and stop_id from stop_times 
# to get all necessary fields, as seen below.
# only trains are considered, buses were eliminated previously.
getFullObject = (timeDoc) ->
	arrivalTime = timeConvert timeDoc["arrival_time"]
	stopDoc = Stops.findOne {stop_id:timeDoc["stop_id"]}
	stationName = stopDoc["stop_name"]
	tripID = timeDoc["trip_id"]
	tripDoc = Trips.findOne {trip_id:tripID}
	serviceID = tripDoc["service_id"]
	direction_id = tripDoc["direction_id"]
	routeID = tripDoc["route_id"]
	routeDoc = Routes.findOne {route_id:routeID}
	line = routeDoc["route_short_name"]
	direction=""
# switch direction to the same value held in Arrivals
	switch line
		when 'GOLD','RED'
			if direction_id is '0'
				direction='N'
			else
				direction='S'
		when 'GREEN','BLUE'
			if direction_id is '0'
				direction='E'
			else
				direction='W'
		else
			direction='U'

	Schedule.update {
		arrival_time: arrivalTime
		stop_name: stationName
		service_id: serviceID
		direction: direction
	},{
		$set:
			arrival_time: arrivalTime
			stop_name: stationName
			service_id: serviceID
			direction: direction
			line: line
	},{ upsert:true }

# convert to unix time
timeConvert = (timeVal) ->
	unixTime = moment(timeVal, 'hh:mm:ss A').unix()
	return unixTime

Meteor.methods {
  getNextScheduled: (agency, stop, line, direction)->
    check agency,String
    check stop,String
    check line,String
    check direction,String
}
###
