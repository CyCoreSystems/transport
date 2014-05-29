Template.queryLine.events {
  'change select[name=line]': (e,template)->
    Session.set 'trackLine',e.currentTarget.value
}

Template.queryLine.selectLine = (name) ->
	if Session.equals 'trackLine',name
		return "selected"
	return ""

Template.queryLine.cutify = (color) ->
	switch (color)
		when 'RED' then return 'Red'
		when 'GOLD' then return 'Gold'
		when 'BLUE' then return 'Blue'
		when 'GREEN' then return 'Green'
	return

Template.queryLine.lines = ->
  return ['RED','GOLD','BLUE','GREEN']
