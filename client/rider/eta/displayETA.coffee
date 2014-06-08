Template.displayETA.realtimes = (direction)->
  stop = Session.get 'etaStop'
  if not stop
    return
  return MergedTimes.find({ station: stop, direction: direction, dataSource:"realtime" },{ sort: ['next_arr'],limit:5 })

Template.displayETA.schedules = (direction)->
  stop = Session.get 'etaStop'
  if not stop
    return
  return MergedTimes.find({ station: stop, direction: direction, dataSource:"schedule" },{ sort: ['next_arr'],limit:5 })

Template.displayETA.hasDirection = (direction)->
  stop = Session.get 'etaStop'
  if not stop
    return false
  return Arrivals.find({ station: stop, direction: direction }).count()

# FIXME:  cruel, brutal, insolent HACK for terminal stations
Template.displayETA.isTerminal = ->
  stop = Session.get 'etaStop'
  if not stop
    return false
  return -1 isnt _.indexOf ['AIRPORT STATION','BANKHEAD STATION','HIGHTOWER STATION','DORAVILLE STATION','NORTH SPRINGS STATION','INDIAN CREEK STATION'],stop
