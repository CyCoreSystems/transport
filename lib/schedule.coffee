@Routes = new Meteor.Collection 'routes'
@Trips = new Meteor.Collection 'trips'
@StopTimes = new Meteor.Collection 'stop_times'
@Schedule = new Meteor.Collection 'schedule'

listIDs = []
tripIDs = []

if Meteor.isServer
	Meteor.startup ->
		grabRouteList color for color in ['GOLD','RED','BLUE','GREEN']
		grabTripList route for route in listIDs

grabRouteList = (col)->
	console.log 'grabbing route for '+col
	trainRoutes = Routes.find({route_short_name:col})
	trainRoutes.forEach storeList
	
grabTripList = (rID)->
	console.log 'grabbing trips for '+rID
	trainTrips = Trips.find({route_id:rID})
	trainTrips.forEach storeList2

storeList = (post) ->
	listIDs.push post["route_id"]

storeList2 = (tripDocs) ->
	tripIDs.push tripDocs["trip_id"]

Meteor.methods {
  getNextScheduled: (agency, stop, line, direction)->
    check agency,String
    check stop,String
    check line,String
    check direction,String
}
