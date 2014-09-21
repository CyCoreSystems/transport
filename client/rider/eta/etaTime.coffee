etaClock = new Tracker.Dependency

Meteor.startup ->
  # Start the global etaClock timer
  setInterval ->
    etaClock.changed()

Template.etaTime.liveETA = ->
  # Rerun each etaClock cycle
  etaClock.depend()
  # Find offset (in seconds) between event time and now
  offset = moment().unix() - @event_time
  # Subtract the offset from the data's ETA
  liveETA = @waiting_seconds - offset
  console.log "LiveETA:",liveETA
  duration = moment.duration(liveETA,"seconds")
  if liveETA > 299
    return "#{Math.floor(duration.asMinutes())} min"
  # For short times, display seconds
  secs = duration.seconds()
  if secs < 0
    return "now"
  if secs < 10
    return "#{duration.minutes()}m 0#{secs}s"
  return "#{duration.minutes()}m #{secs}s"
