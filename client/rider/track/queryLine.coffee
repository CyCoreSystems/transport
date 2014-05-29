Template.queryLine.events {
  'change select[name=line]': (e,template)->
    Session.set 'trackLine',e.currentTarget.value
}

Template.queryLine.cutify = (color) ->
  return _.str.capitalize(color)
