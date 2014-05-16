Template.queryETA.events {
  'change select[name=stop]': (e,template)->
    Session.set 'etaStop',e.currentTarget.value
}

Template.queryETA.stop = ->
  return Session.get 'etaStop'

Template.queryETA.stops = ->
  return Stations.find({},{ sort: ['displayName'] })

Template.queryETA.selectedStation = (name)->
  if Session.equals 'etaStop',name
    return "selected"
  return ""
