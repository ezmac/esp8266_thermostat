# ESP8266 wifi enabled thermostat

I use an electric oil heater for one room and got tired of getting up in the night to adjust it.  I also wanted to play around with an esp8266 and some electricity.  This is the esp8266 thermostat.

![diagram](diagram.png)
This was my first venture into lua and uses NodeMCU.  I picked up parts of many other resources, which regretfully I did not write down.
Basic idea is there's a thermostat object that checks the temp on an interval and compares to an ideal_temperature.  

the put method accepts a json object and will update ideal_temperature and interval.  interval is in ms.

I haven't thoroughly checked the fritzing diagram, but it looks right.  The LED indicates that it's on and can be used for testing.
