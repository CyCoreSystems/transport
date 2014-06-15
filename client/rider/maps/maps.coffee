key='https://maps.googleapis.com/maps/api/js?key=AIzaSyDAVGnGDx8N0e7HrijuJokmxO5R908oc-M'

Meteor.Loader.loadJs key,Template.maps.rendered

initialize = ->
	mapOptions =
		zoom: 8,
		center: new google.maps.LatLng(-34.397, 150.644)
	map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions)

Template.maps.rendered = ->
	initialize()
