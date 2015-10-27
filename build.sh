#!/bin/bash
echo writing init.lua
esp file write init.lua init.lua
echo writing http.lua
esp file write http.lua http.lua
echo writing thermostat.lua 
esp file write thermostat.lua thermostat.lua
echo writing wifi_settings.json
esp file write wifi_settings.json wifi_settings.json
#esp file write 

