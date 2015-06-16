step = 0
log = document.getElementById('log')
setInterval ->
  switch step
    when 0
      log.innerHTML = 'Recording in 4..'
    when 1
      log.innerHTML = 'Recording in 3..'
    when 2
      log.innerHTML = 'Recording in 2..'
    when 3
      log.innerHTML = 'Recording in 1..'
    when 4
      log.innerHTML = 'Recording NOW'
      Soarec.get().events = []
      Soarec.get().toggle()
    when 9
      log.innerHTML = 'Recording finished'
      Soarec.get().toggle()
  step++
, 1000
