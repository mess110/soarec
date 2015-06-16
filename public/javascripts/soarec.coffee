SOAREC_API_URL = '/report.json'
REPORT_INTERVAL = 5000
DEBUG = false
RECORDERS = [ 'mousemove', 'mouseenter', 'mouseleave', 'mouseover', 'mouseup'
              'mousedown', 'scroll' ]

window.Soarec = class Soarec
  instance = null

  class PrivateClass
    constructor:  ->
      @recording = false
      @events = []

    toggle: ->
      @recording = !@recording

  @get: (message) ->
    instance ?= new PrivateClass(message)

recordEvent = (event) ->
  hash = {
    # TODO: scroll
    type: event.type
    x: event.x
    y: event.y
    timestamp: event.timestamp
    button: event.button
    toElement: {
      id: event.toElement.id
      classList: event.toElement.classList
      nodeName: event.toElement.nodeName
    } if event.toElement?
  }
  console.log event if DEBUG
  Soarec.get().events.push hash

for recorder in RECORDERS
  document.addEventListener(recorder, recordEvent)

sendReport = () ->
  r = new XMLHttpRequest
  r.open 'POST', SOAREC_API_URL, true
  json_string = JSON.stringify(events: Soarec.get().events, timestamp: new Date().getTime().toString())
  console.log json_string if DEBUG
  Soarec.get().events = []
  r.send json_string if Soarec.get().recording

setInterval(sendReport, REPORT_INTERVAL)
