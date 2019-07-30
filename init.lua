--load credentials & config
dofile("conf.lua")

function startup(t2)
    t2:unregister()
    if file.open("init.lua") == nil then
        print("init.lua deleted")
    else
        print("Running")
        file.close("init.lua")
        --dofile("wifi_debug.lua")
        dofile("robot.lua")
    end
end

--wifi.sta.clearconfig()

wifi_mode = wifi.getmode()
print("Current wifi mode :: "..wifi_mode)
if wifi_mode ~= wifi.STATION then
    print("Changing wifi mode to STATION")
    wifi.setmode(wifi.STATION,true)
end

if wifi.sta.status() == wifi.STA_GOTIP then
    print("wifi already connected. ")
elseif wifi.sta.status() == wifi.STA_CONNECTING then
    print("wifi connection in progress ...")
else
    print("set up wifi mode to connect to :: " .. SSID .. ":"..PASSWORD)
    wifi.sta.clearconfig()
    station_cfg={}
    station_cfg.ssid=SSID
    station_cfg.pwd=PASSWORD
    station_cfg.save=true
    wifi.sta.config(station_cfg)
    wifi.sta.connect()
end
--tmr.ALARM_AUTO
--tmr.ALARM_SINGLE
--tobj:unregister()

local bootDelayTimer = tmr.create()
bootDelayTimer:register(PRE_BOOT_DELAY * 1000, tmr.ALARM_SINGLE, function(t2) startup(t2) end)


local wifiWaitTimer = tmr.create()
wifiWaitTimer:register(1000, tmr.ALARM_AUTO, function (t) print("expired");
    if wifi.sta.getip()== nil then
        print("IP unavaiable, Waiting...")
    else
        t:unregister()
        print("Config done, IP is "..wifi.sta.getip())
        print("You have "..PRE_BOOT_DELAY.." seconds to abort Startup using bootDelayTimer:stop()")
        print("Waiting...")
        bootDelayTimer:start()
    end
end)
wifiWaitTimer:start()

