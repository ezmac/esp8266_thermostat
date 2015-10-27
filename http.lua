
require 'thermostat'

t = Thermostat:new(nil, 2,77)
t:tick()

print("Testing")
print(t.interval)
wifi.sta.config(wifiCreds.sid,wifiCreds.password)
wifi.setmode(wifi.STATION)
backoff=     500000
delay_time  =1000000
retry_count =0
retry_limit =5
while(wifi.sta.status() ~= 5) do
  print('wifi status not connected')
  print(wifi.sta.status())
  print(wifi.sta.getip())
  if (wifi.sta.status() ~= 1) then
    print("trying to connect")
    wifi.sta.connect()
  else
    print("not trying to connect")
  end
  delay_time = delay_time + backoff
  tmr.delay(delay_time)
  print("after delay")
  print(wifi.sta.status())
  print(wifi.sta.getip())
  if(delay_time>5000000)then
    print("disconnecting")
    wifi.sta.disconnect()
    delay_time = 1000000
  end
  if (retry_count > retry_limit) then
    node.reset()
    else
      retry_count = retry_count + 1
  end
end

print(wifi.sta.getip())
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        --local buf = "hahaha";
        print("Received connection")
        local buf=""
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if method ~= nil then
          print("Method: "..method)
        end
        if path ~= nil then
          print("Path: "..path)
        end
        if vars ~= nil then
          print("vars: "..vars)
        end

        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        if method ~= nil then
          print("Method: "..method)
        end
        if path ~= nil then
          print("Path: "..path)
        end
        if vars ~= nil then
          print("vars: "..vars)
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        if(method == 'PUT' or method == 'put') then
          print("method was put.  Content-Length: ")
          contentLength = string.match(request,"Content%-Length:%s*(%d+)")
          print(contentLength)
          --for i in string.gmatch(request,"Content%-Length:%s*(%d*)") do
            --print("Response part start")
            --print(i)
            --print("Response part end")
          --end
          body = string.sub(request,(contentLength*-1))
          print("Got this json")
          print(body)
          jsonBody = json.decode(body)
          if(jsonBody['ideal_temperature'] ~= nil) then
            t.ideal_temperature = jsonBody['ideal_temperature']
            t:tick()
          end
          if(jsonBody['interval'] ~= nil) then
            print("Got an interval")
            t:setInterval(jsonBody['interval'])
          end

        else
          buf = (t:toJSON())
        end
        --buf = buf.."<h1> ESP8266 Web Server</h1>";
        --buf = buf.."<p>GPIO0 <a href=\"?pin=ON1\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF1\"><button>OFF</button></a></p>";
        --buf = buf.."<p>GPIO2 <a href=\"?pin=ON2\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF2\"><button>OFF</button></a></p>";
        --local _on,_off = "",""
        --if(_GET.pin == "ON1")then
              --gpio.write(led1, gpio.HIGH);
        --elseif(_GET.pin == "OFF1")then
              --gpio.write(led1, gpio.LOW);
        --elseif(_GET.pin == "ON2")then
              --gpio.write(led2, gpio.HIGH);
        --elseif(_GET.pin == "OFF2")then
              --gpio.write(led2, gpio.LOW);
        --end
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
