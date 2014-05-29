@Lines = new Meteor.Collection 'lines'

if Meteor.isServer
  Lines.remove {}
  lines = [
    { feedName: 'RED', humanName: 'Red' }
    { feedName: 'GOLD', humanName: 'Gold' }
    { feedName: 'BLUE', humanName: 'Blue' }
    { feedName: 'GREEN', humanName: 'Green' }
  ]
  _.each lines,(line)->
    Lines.insert line
