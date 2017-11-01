
require 'thermostat'

t = Thermostat:new(nil, 2,77)
t:tick()
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
  conn:on("receive", function(client,request)
    print("Received connection")
    local response = {}

   -- if you're sending back HTML over HTTP you'll want something like this instead
    local response = {"HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n"}

    -- sends and removes the first element from the 'response' table
    local function send(localSocket)
      if #response > 0 then
        localSocket:send(table.remove(response, 1))
      else
        localSocket:close()
       response = nil
      end
    end

    -- triggers the send() function again once the first chunk of data was sent
    client:on("sent", send)

    local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP")
    if method ~= nil then
      print("Method: "..method)
    end
    if path ~= nil then
      print("Path: "..path)
    end
    if vars ~= nil then
      print("vars: "..vars)
    end

    --    local _GET = {}
    --    if (vars ~= nil)then
    --      for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
    --        _GET[k] = v
    --      end
    --    end
    if(method == 'PUT' or method == 'put') then
      print("method was put.  Content-Length: ")
      contentLength = string.match(request,"Content%-Length:%s*(%d+)")
      print(contentLength)
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
      -- the method wasn't put
      print("You def got to the else part")
      response[#response + 1]= t:toJSON()
    end
    send(client)
    collectgarbage()
  end)
end)
