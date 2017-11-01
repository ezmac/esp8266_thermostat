json=require "sjson"

Thermostat = {}
function Thermostat:setInterval(i)
  self.interval = i
  print("setting interval to "..self.interval)
  tmr.stop(0)
  --  TODO 
  --  TODO 
  --  TODO this is the probelm
  -- 1-6,870,947
  tmr.alarm(0,self.interval, tmr.ALARM_AUTO, function() t:tick() end)
end
function Thermostat:on()
    --gpio.write(self.temperature_gpio_pin, gpio.HIGH)
    self.state = "on"
    print("On Wait")
end
function Thermostat:off()
    --gpio.write(self.temperature_gpio_pin, gpio.LOW)
    self.state = "off"
    print("off Wait")
end
function Thermostat:new(o,temperature_gpio_pin, ideal_temperature, interval)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.temperature_gpio_pin = temperature_gpio_pin
  self.temp = 70
  self.ideal_temperature = ideal_temperature or 70
  self.state="off"
  self.interval = interval or 6000000 -- 12 seconds
  self:setInterval(self.interval)
  --self.interval = interval or 1200000000 -- 10 minute default
  --gpio.mode(self.temperature_gpio_pin,gpio.OUTPUT)
  return o
end
function Thermostat:print_ideal_temp()
  print(self.ideal_temperature)
end
function Thermostat:getIdealTemp()
  return (self.ideal_temperature)
end
function Thermostat:setIdealTemp(temp)
  self.ideal_temperature = temp
end

function Thermostat:getState()
  return self.state
end
function Thermostat:getTemp()
  -- formula is 100*V - 50
  return 1
  --mv = adc.read(0)
  --v = mv/1000
  --print("V="..v)
  --c = (100*v)-50
  --print("C="..c)
  --f = (c*1.8)+32
  --print("F="..f)
  --self.temp=f
  --return self.temp
end

function Thermostat:setTemp(t)
  print("YOU SHOULDN'T USE THIS EXCEPT IN TESTING")
  self.temp=t
end

function Thermostat:tick()
  self.temp=self:getTemp()
  if self.temp > self:getIdealTemp() then
    self:off()
  else
    self:on()
  end
  self.state= self:getState()
end
function Thermostat:toJSON()
  self:getTemp()
  print("Json encoding")
  local jsonout = json.encode(self)
  print(jsonout)
  return jsonout
end
