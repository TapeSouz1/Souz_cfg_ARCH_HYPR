#!/bin/bash
# Проверяет, запущен ли wlsunset
if pgrep -x "wlsunset" > /dev/null; then
    echo ""  # Луна — включено
else
    echo ""  # Солнце — выключено
fi