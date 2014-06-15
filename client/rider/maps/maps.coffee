key='AIzaSyDAVGnGDx8N0e7HrijuJokmxO5R908oc-M'

initialize = ->
	mapOptions =
		zoom: 8,
		center: new google.maps.LatLng(-34.397, 150.644)
	map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions)
