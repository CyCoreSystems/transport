analyzeInterval=null
Meteor.startup ->
	analyzeData()
	analyzeInterval = Meteor.setInterval analyzeData, 10000

analyzeData = ->
	#TODO add analytics for different functions
	return
