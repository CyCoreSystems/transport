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

refreshSchedule = (col) ->
	console.log 'grabbing routes for '+col
	routeCursor = Routes.find {route_short_name:col}
	routeCursor.forEach routeToTrip

routeToTrip = (routeDoc) ->
	console.log 'grabbing trips for route '+routeDoc["route_id"]
	tripCursor = Trips.find {route_id:routeDoc["route_id"]}
	tripCursor.forEach infoFromTrip

infoFromTrip = (tripDoc) ->
	timeCursor = StopTimes.find {trip_id:tripDoc["trip_id"]}
	timeCursor.forEach getFullObject

getFullObject = (timeDoc) ->
	arrivalTime = timeDoc["arrival_time"]
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

Meteor.methods {
  getNextScheduled: (agency, stop, line, direction)->
    check agency,String
    check stop,String
    check line,String
    check direction,String
}
