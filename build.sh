#!/bin/bash
echo writing init.lua
esp file write init.lua init.lua
echo writing simplehttp.lua
esp file write simplehttp.lua http.lua
echo writing thermostat.lua 
esp file write thermostat.lua thermostat.lua
echo writing wifi_settings.lua
esp file write wifi_settings.json wifi_settings.json
#esp file write 

