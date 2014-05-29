Template.eta.stationURL = ->
  stop = Session.get 'etaStop'
  if not stop
    return false
  return Stations.findOne({name: stop})?.url

