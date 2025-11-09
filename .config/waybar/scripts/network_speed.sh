#!/bin/bash
# Автоопределение активного интерфейса
interface=$(ip route get 8.8.8.8 2>&1 | awk '{for(i=1;i<=NF;i++) if ($i == "dev") print $(i+1)}' | head -n1)

# Проверка наличия активного интерфейса
if [ -z "$interface" ] || [ ! -d "/sys/class/net/$interface" ]; then
    exit 0
fi

# Получение текущих значений
old_rx=$(cat /sys/class/net/$interface/statistics/rx_bytes)
old_tx=$(cat /sys/class/net/$interface/statistics/tx_bytes)
sleep 1
new_rx=$(cat /sys/class/net/$interface/statistics/rx_bytes)
new_tx=$(cat /sys/class/net/$interface/statistics/tx_bytes)

# Расчет скорости
rx_speed=$(( (new_rx - old_rx) / 1024 ))
tx_speed=$(( (new_tx - old_tx) / 1024 ))

# Форматирование вывода
if [ $rx_speed -lt 1024 ]; then
    rx_display="${rx_speed}KB/s"
else
    rx_display="$(printf "%.1f" $(echo "$rx_speed / 1024" | bc -l))MB/s"
fi

if [ $tx_speed -lt 1024 ]; then
    tx_display="${tx_speed}KB/s"
else
    tx_display="$(printf "%.1f" $(echo "$tx_speed / 1024" | bc -l))MB/s"
fi

# Вывод с иконками
echo " $rx_display ↓ ↑ $tx_display"
