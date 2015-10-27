# ESP8266 wifi enabled thermostat

A short readme about the project, to be replaced later.

This was my first venture into lua and uses NodeMCU.  I picked up parts of many other resources, which regretfully I did not write down.
Basic idea is there's a thermostat object that checks the temp on an interval and compares to an ideal_temperature.  

the put method accepts a json object and will update ideal_temperature and interval.  interval is in ms.

I'll try to update with a fritzing schematic later.

