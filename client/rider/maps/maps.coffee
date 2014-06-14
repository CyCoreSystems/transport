Template.maps.createMap = ->
	window.onload = Meteor.Loader.loadJs "https://maps.googleapis.com/maps/api/js?key=AIzaSyDAVGnGDx8N0e7HrijuJokmxO5R908oc-M",startMap
	
startMap = ->
	console.log 'map loaded'

initialize = ->
	mapOptions =
		zoom: 8,
		center: new google.maps.LatLng(-34.397, 150.644)
	map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions)
