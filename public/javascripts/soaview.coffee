SOAREC_API_URL = '/report.json'

addCanvas = (heatmapData) ->
  c = document.createElement('canvas')
  c.setAttribute('id', 'canvas')
  c.setAttribute('style', 'z-index: -1; position: absolute; padding: 0px; left: 0px; top: 0px; width: 100%; height: 100%')
  c.setAttribute('width', window.innerWidth)
  c.setAttribute('height', window.innerHeight)
  document.body.appendChild(c)
  simpleheat('canvas').data(heatmapData).draw()

addFakeCursor = () ->
  s = document.createElement('span')
  s.setAttribute('id', 'fake-cursor')
  s.setAttribute('style', 'position: absolute; width: 10px; height: 10px; background-color: black; overflow: hidden')
  s.innerHTML = '.'
  document.body.appendChild(s)

setFakeCursorPos = (event) ->
  fakeCursor = document.getElementById('fake-cursor')
  fakeCursor.style.left = "#{event.x}px"
  fakeCursor.style.top = "#{event.y}px"
  return

draw = (result) ->
  addFakeCursor()

  heatmapData = []
  sleep_time = 0
  for ev in result[result.length - 1]['events']
    weight = if ev.type == 'mousedown' then 1 else 0.01
    heatmapData.push [ev.x, ev.y, weight]
    sleep_time += 50
    setTimeout(((ev) ->
      ->
        setFakeCursorPos ev
        return
    )(ev), sleep_time)

  addCanvas(heatmapData)

playback = () ->
  r = new XMLHttpRequest
  r.onreadystatechange = (data) ->
    return if r.readyState != 4 or r.status != 200
    draw(JSON.parse(r.responseText))
    return
  r.open 'GET', SOAREC_API_URL + "?timestamp[$gte]=#{new Date().getTime() - 10 * 60 * 1000}"
  r.send()

playback()
