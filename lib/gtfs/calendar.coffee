@Calendar = new Meteor.Collection 'calendar'

if Meteor.isServer
  # Remove all on start (this is a poor-man's data refresh)
  Calendar.remove {}

  # Hard-code for now
  calendar = [
    {
      service_id: 2
      monday: 0
      tuesday: 0
      wednesday: 0
      thursday: 0
      friday: 0
      saturday: 0
      sunday: 0
      start_date: '20131214'
      end_date: '20141218'
    }
    {
      service_id: 3
      monday: 0
      tuesday: 0
      wednesday: 0
      thursday: 0
      friday: 0
      saturday: 1
      sunday: 0
      start_date: '20131214'
      end_date: '20141218'
    }
    {
      service_id: 4
      monday: 0
      tuesday: 0
      wednesday: 0
      thursday: 0
      friday: 0
      saturday: 0
      sunday: 1
      start_date: '20131214'
      end_date: '20141218'
    }
    {
      service_id: 5
      monday: 1
      tuesday: 1
      wednesday: 1
      thursday: 1
      friday: 1
      saturday: 0
      sunday: 0
      start_date: '20131214'
      end_date: '20141218'
    }
  ]
  _.each calendar,(i)->
    Calendar.insert i
    return
  return

  # Change HTTP.get url to working url
  # Re-add all data from service
  res = HTTP.get 'http://api.navdash.com/trips'
  if res.statusCode isnt 200
    throw new Meteor.Error(500, 'Failed to fetch trips list')
  if not _.isArray res.data
    throw new Meteor.Error(500, 'Bad data received for trips list')
  _.each res.data,(trip)->
    Trips.insert trip
    return
  
