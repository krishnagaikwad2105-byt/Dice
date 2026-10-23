@echo off
title Champal Pani - Mobile Test Server
echo ========================================================
echo       CHAMPAL PANI (चंपाळ पाणी) - MOBILE SERVER
echo ========================================================
echo.
echo Make sure your mobile phone is connected to the same Wi-Fi network.
echo.
echo Open this URL in your mobile phone browser (Chrome/Safari):
echo.
echo     http://172.16.20.152:8080
echo.
echo TIP: In mobile browser menu, tap "Add to Home screen"
echo      to test it like an installed mobile app!
echo.
echo ========================================================
echo Server running... (Press Ctrl+C to stop)
echo.
python -m http.server 8080 --directory build\web --bind 0.0.0.0
pause
