----------------------------------------------------
---Motor initialization
----------------------------------------------------
--motordrive: init.lua
--camera_trigger_pin = 6
--LED_INDICATOR_PIN = 5
print("Initialize camera trigger pin ")
gpio.mode(CAMERA_TRIGGER_PIN,gpio.OUTPUT)
gpio.write(CAMERA_TRIGGER_PIN,gpio.HIGH)

print("Initialize led indicator pin ")
gpio.mode(LED_INDICATOR_PIN,gpio.OUTPUT)
gpio.write(LED_INDICATOR_PIN,gpio.LOW)

--stopPulseTimer = tmr.create()
--stopPulseTimer:register(PULSE_MILLIS, tmr.ALARM_SINGLE, function(t2)
--    stopPulseTimer:stop()
--    gpio.write(CAMERA_TRIGGER_PIN,gpio.HIGH)
--    print("Stop trigger pulse")
--end)
--
--stopLedTimer = tmr.create()
--stopLedTimer:register(INDICATOR_LED_DURATION * 1000, tmr.ALARM_SINGLE, function(t3)
--    stopLedTimer:stop()
--    gpio.write(LED_INDICATOR_PIN,gpio.LOW)
--    print("Stop led")
--end)

function triggerCamera()
    http.get(GOPRO_API, nil, function(code, data)
        if (code < 0) then
            print("HTTP request failed")
        else
            print("GOPRO request successful")
            print(code, data)
        end
    end)
end

function triggerGpsAndCamera()

    print("Start trigger pulse ")
    gpio.write(CAMERA_TRIGGER_PIN,gpio.LOW)
    stopPulseTimer = tmr.create()
    stopPulseTimer:register(PULSE_MILLIS, tmr.ALARM_SINGLE, function(t2)
        stopPulseTimer:unregister()
        gpio.write(CAMERA_TRIGGER_PIN,gpio.HIGH)
        print("Stop trigger pulse")
    end)

    if not stopPulseTimer:start() then print("unable to start timer :: stopPulseTimer") end


    triggerCamera()

    gpio.write(LED_INDICATOR_PIN,gpio.HIGH)
    stopLedTimer = tmr.create()
    stopLedTimer:register(INDICATOR_LED_DURATION * 1000, tmr.ALARM_SINGLE, function(t3)
        stopLedTimer:unregister()
        gpio.write(LED_INDICATOR_PIN,gpio.LOW)
        print("Stop led")
    end)
    if not stopLedTimer:start() then print("unable to start timer :: stopLedTimer") end
end

cameraTriggerTimer = tmr.create()
cameraTriggerTimer:register(CAMERA_TRIGGER_DELAY * 1000, tmr.ALARM_AUTO, function(t2)
    triggerGpsAndCamera()
end)

triggerGpsAndCamera() --first time invocation
cameraTriggerTimer:start() --periodic invocation






