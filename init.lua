json = require "cjson"

function unrequire(m)
    package.loaded[m] = nil
    _G[m] = nil
end

function getWifiCreds()
  local json = require "cjson"
  file.open("wifi_settings.json","r")
  local theSettings = file.read()
  settings = json.decode(theSettings)
  file.close()
  return settings
end
   




function abortInit()
  -- initailize abort boolean flag
  abort = false
  print('Press ENTER to abort startup')
  -- if <CR> is pressed, call abortTest
  uart.on('data', '\r', abortTest, 0)
  -- start timer to execute startup function in 5 seconds
  tmr.alarm(0,5000,0,startup)
end

function abortTest(data)
  -- user requested abort
  abort = true
  -- turns off uart scanning
  uart.on('data')
end

function startup()
  uart.on('data')
  -- if user requested abort, exit
  if abort == true then
    print('startup aborted')
    return
  end
  -- otherwise, start up
  print('in startup')
  wifiCreds = getWifiCreds()
  dofile('http.lua')
end

tmr.alarm(0,1000,0,abortInit)           -- call abortInit after 1s
