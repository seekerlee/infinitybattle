@echo off
rmdir logs /s /Q
copy map.w3x "D:\Documents\Warcraft III\Maps\my" /Y
jasshelper script\blizzard\common.j script\blizzard\blizzard.j "D:\Documents\Warcraft III\Maps\my\map.w3x"

