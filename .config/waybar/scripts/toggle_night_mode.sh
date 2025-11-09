#!/bin/bash
if pgrep -x "wlsunset" > /dev/null; then
    # Выключаем
    pkill wlsunset
    # Сбрасываем цвет (белый)
    gamma -r 1.0 -g 1.0 -b 1.0 2>/dev/null || true
else
    # Включаем с тёплым светом
    wlsunset -l 57.7676:40.9262 -t 5500:2700 &
fi

# Обновляем иконку в Waybar (custom/night-mode — 4-й в right)
pkill waybar && sleep 0.1 && waybar -c ~/.config/waybar/config.json -s ~/.config/waybar/style.css &