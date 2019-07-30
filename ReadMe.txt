About this project : 

    Trigger a ReachM+ GPS module and a GoPro session camera using a Wemos D1 mini at the same time to get high accuracy gps info for images captured by gopro.

Steps to use :
    1. Dump the firmware in to Wemos D1 Mini (or any other esp8266 variant) and ensure that it is working fine
    2. Edit conf.lua and update your Gopro Session camera's SSID and Password
    3. Connect Reach M+ to Wemos D1 Mini
        Connections
        Reach M+                     Wemos D1 Mini
        ------------------------------------------
        C1 Time marker pin              D6
        Indicator LED                   D5              (Optional. just to indicate D1 is triggering the camera & GPS devices)


