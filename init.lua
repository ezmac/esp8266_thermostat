json = require "sjson"

function unrequire(m)
    package.loaded[m] = nil
    _G[m] = nil
end

function getWifiCreds()
  local json = require "sjson"
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
  dofile('http.lua')
end

-- new shit from the wiki
-- Define WiFi station event callbacks 
wifi_connect_event = function(T) 
  print("Connection to AP("..T.SSID..") established!")
  print("Waiting for IP address...")
  if disconnect_ct ~= nil then disconnect_ct = nil end  
end

wifi_got_ip_event = function(T) 
  -- Note: Having an IP address does not mean there is internet access!
  -- Internet connectivity can be determined with net.dns.resolve().    
  print("Wifi connection is ready! IP address is: "..T.IP)
  print("Startup will resume momentarily, you have 3 seconds to abort.")
  print("Waiting...") 
  tmr.create():alarm(3000, tmr.ALARM_SINGLE, startup)
end

wifi_disconnect_event = function(T)
  if T.reason == wifi.eventmon.reason.ASSOC_LEAVE then 
    --the station has disassociated from a previously connected AP
    return 
  end
  -- total_tries: how many times the station will attempt to connect to the AP. Should consider AP reboot duration.
  local total_tries = 75
  print("\nWiFi connection to AP("..T.SSID..") has failed!")

  --There are many possible disconnect reasons, the following iterates through 
  --the list and returns the string corresponding to the disconnect reason.
  for key,val in pairs(wifi.eventmon.reason) do
    if val == T.reason then
      print("Disconnect reason: "..val.."("..key..")")
      break
    end
  end

  if disconnect_ct == nil then 
    disconnect_ct = 1 
  else
    disconnect_ct = disconnect_ct + 1 
  end
  if disconnect_ct < total_tries then 
    print("Retrying connection...(attempt "..(disconnect_ct+1).." of "..total_tries..")")
  else
    wifi.sta.disconnect()
    print("Aborting connection to AP!")
    disconnect_ct = nil  
  end
end

-- Register WiFi Station event callbacks
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_got_ip_event)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, wifi_disconnect_event)

print("Connecting to WiFi access point...")
wifi.setmode(wifi.STATION)
wifi.sta.config({ssid='BlueWhale', pwd='Bear3605'})
-- wifi.sta.connect() not necessary because config() uses auto-connect=true by default

