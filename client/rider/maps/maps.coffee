@Shapes = new Meteor.Collection 'shapes'
map = null
initialize = ->
	mapOptions =
		zoom: 12,
		center: new google.maps.LatLng(33.7500531, -84.3895395)
	map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions)

Template.maps.rendered = ->
	initialize()

Template.maps.events {
	'change select[name=line]': (e,template)->
		Session.set 'mapLine',e.currentTarget.value
}

Template.maps.selectLine = (name) ->
	if Session.equals 'mapLine',name
		return "selected"
	return ""

Template.maps.lines = ->
	return Lines.find()

Template.maps.lineChosen = ->
	line = Session.get 'mapLine'
	console.log _.uniq(_.pluck(Schedule.find({line:line}).fetch(),'shape_id'))
	return _.uniq(_.pluck(Schedule.find({line:line}).fetch(),'shape_id'))

Template.maps.drawRoute = (shapeID) ->
	shapeCursor = Shapes.find({shape_id:shapeID}).fetch()
	drawShapes shapeCursor

drawShapes = (cursor) ->
	i =0
	shapeArray = []
	while i<cursor.length
		console.log 'drawing: '+cursor[i].shape_pt_lat+' '+cursor[i].shape_pt_lon
		shapeArray.push google.maps.LatLng(cursor[i].shape_pt_lat,cursor[i].shape_pt_lon)
		i++
	fp = new google.maps.Polyline({
		path: shapeArray,
		geodesic: true,
		strokeColor: '#FF0000',
		strokeOpacity: 1.0,
		strokeWeight: 2
	})
	fp.setMap(map)
