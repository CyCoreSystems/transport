Template.queryLine.events {
  'change select[name=line]': (e,template)->
    Session.set 'trackLine',e.currentTarget.value
    Session.set 'ttID',null
}

Template.queryLine.selectLine = (name) ->
	if Session.equals 'trackLine',name
		return "selected"
	return ""

Template.queryLine.lines = ->
  return Lines.find()
