#!/bin/bash
export PATH=$PATH:$HOME/.nodenv/versions/7.10.0/bin/

~/.nodenv/versions/7.10.0/bin/nodemcu-tool upload init.lua http.lua thermostat.lua wifi_settings.json 
