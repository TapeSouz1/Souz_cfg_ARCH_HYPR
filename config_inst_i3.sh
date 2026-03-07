#!/bin/bash
# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Начало установки конфигурации i3...${NC}"
# 1. Создание базовой структуры директорий
echo -e "${YELLOW}Создание директорий...${NC}"
mkdir -p "$HOME/.config/i3"
mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.config/picom"
mkdir -p "$HOME/.config/polybar/scripts"
mkdir -p "$HOME/.config/fastfetch"
mkdir -p "$HOME/.config/rofi"
mkdir -p "$HOME/Pictures/Wallpapers"
mkdir -p "$HOME/Pictures/Screenshots"

backup_file() {
    if [ -f "$1" ]; then
        cp "$1" "${1}.bak.$(date +%F_%H-%M-%S)"
        echo -e "${YELLOW}Бэкап создан: ${1}.bak...${NC}"
    fi
}
echo -e "${YELLOW}Настройка i3...${NC}"
backup_file "$HOME/.config/i3/config"

cat << 'EOF' > "$HOME/.config/i3/config"

#new_window pixel 4
#i3-msg restart
#new_float pixel 4
#hide_edge_borders both
#smart_borders on
#smart_borders no_gaps

# i3 config file (v4)
#exec_always --no-startup-id "export __GLX_VENDOR_LIBRARY_NAME=nvidia"
#exec_always --no-startup-id "export LIBVA_DRIVER_NAME=nvidia"
exec_always --no-startup-id pulseaudio --start
exec_always --no-startup-id "export GDK_SCALE=1"
exec_always --no-startup-id "export GDK_DPI_SCALE=1"
exec_always --no-startup-id "export QT_SCALE_FACTOR=1"
exec_always --no-startup-id "export QT_AUTO_SCREEN_SCALE_FACTOR=1"
exec_always --no-startup-id "export QT_QPA_PLATFORM=xcb"
exec_always --no-startup-id "export QT_QPA_PLATFORMTHEME=qt6ct"
exec_always --no-startup-id "export QT_STYLE_OVERRIDE=kvantum"
exec_always --no-startup-id "export QT_FONT_DPI=96"
exec_always --no-startup-id "export QT_ENABLE_HIGHDPI_SCALING=1"
exec_always --no-startup-id "export GDK_BACKEND=x11"
exec_always --no-startup-id "export XDG_CURRENT_DESKTOP=i3"
exec_always --no-startup-id "export XDG_SESSION_TYPE=x11"
exec_always --no-startup-id "export FREETYPE_PROPERTIES='truetype:interpreter-version=40'"
exec_always --no-startup-id "export XCURSOR_THEME=ArcMidnight-cursors"
exec_always --no-startup-id "export XCURSOR_SIZE=24"
exec_always --no-startup-id "xsetroot -cursor_name left_ptr"
exec_always --no-startup-id picom -b --corner-radius 16
#exec_always --no-startup-id "nvidia-settings --assign CurrentMetaMode='nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }'"
#bindsym $mod1+x --no-startup-id ~/.screenlayout/monic1.sh
exec_always --no-startup-id nitrogen --restore
#exec_always --no-startup-id ~/.config/polybar/scripts/mon.sh
exec --no-startup-id xset s off
exec --no-startup-id xset -dpms
set $mod Mod4
set $mod1 Mod1

bindsym $mod+shift+s exec flameshot gui
bindsym $mod1+shift+x exec --no-starup-id ~/.screenlayout/monic1.sh
# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:monospace 8

# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
#font pango:DejaVu Sans Mono 8

# Start XDG autostart .desktop files using dex. See also
# https://wiki.archlinux.org/index.php/XDG_Autostart
exec --no-startup-id dex --autostart --environment i3

# The combination of xss-lock, nm-applet and pactl is a popular choice, so
# they are included here as an example. Modify as you see fit.

# xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
# screen before suspend. Use loginctl lock-session to lock your screen.
exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork

# NetworkManager is the most popular way to manage wireless networks on Linux,
# and nm-applet is a desktop environment-independent system tray GUI for it.
exec --no-startup-id nm-applet

# Use pactl to adjust volume in PulseAudio.
set $refresh_i3status killall -SIGUSR1 i3status
bindsym $mod1+w exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% && $refresh_i3status
bindsym $mod1+e exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% && $refresh_i3status
#bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
#bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# move tiling windows via drag & drop by left-clicking into the title bar,
# or left-clicking anywhere into the window while holding the floating modifier.
tiling_drag modifier titlebar

# start a terminal
bindsym $mod+Return exec kitty
bindsym $mod+m exec rofi -show drun -show-icons -config ~/.config/rofi/config.rasi

# kill focused window
bindsym $mod+q kill

# alternatively, you can use the cursor keys:
bindsym $mod1+Left focus left
bindsym $mod1+Down focus down
bindsym $mod1+Up focus up
bindsym $mod1+Right focus right
bindsym $mod1+n exec kitty --hold -e /usr/bin/fastfetch --file ~/.config/fastfetch/my_logo.txt;
# move focused window
bindsym $mod1+Shift+j move left
bindsym $mod1+Shift+k move down
bindsym $mod1+Shift+l move up
bindsym $mod1+Shift+semicolon move right

# split in horizontal orientation
bindsym $mod1+b split h

# split in vertical orientation
bindsym $mod1+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod1+Shift+space floating toggle

# change focus between tiling / floating windows
#bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod1+a focus parent

# focus the child container
#bindsym $mod1+d focus child

# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

# switch to workspace
bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
        bindsym j resize shrink width 10 px or 10 ppt
        bindsym k resize grow height 10 px or 10 ppt
        bindsym l resize shrink height 10 px or 10 ppt
        bindsym semicolon resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape or $mod+r
        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym $mod+r mode "de
EOFfault"
}

exec --no-startup-id setxkbmap -layout us,ru -option "grp:win_space_toggle"
#exec xrandr --output HDMI-0 --mode 1920x1080 --pos 0x0
#exec xrandr --output DP-0 --mode 1920x1080 --pos 1920x0
bindsym $mod+r mode "resize"
EOF

cat << 'EOF' > "$HOME/.config/i3/monic1.sh"
#!/bin/sh
xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-1 --off --output DVI-D-1 --off
EOF

cat << 'EOF' > "$HOME/.config/polybar/config"
;==========================================================
;
;
;   ██████╗  ██████╗ ██╗  ██╗   ██╗██████╗  █████╗ ██████╗
;   ██╔══██╗██╔═══██╗██║  ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗
;   ██████╔╝██║   ██║██║   ╚████╔╝ ██████╔╝███████║██████╔╝
;   ██╔═══╝ ██║   ██║██║    ╚██╔╝  ██╔══██╗██╔══██║██╔══██╗
;   ██║     ╚██████╔╝███████╗██║   ██████╔╝██║  ██║██║  ██║
;   ╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
;
;
;   To learn more about how to configure Polybar
;   go to https://github.com/polybar/polybar
;
;   The README contains a lot of information
;
;==========================================================

[colors]
background = #140C23
background-alt = #201237
foreground = #C4B0D8
primary = #A88CFF
secondary = #3C1E5F
alert = #E6B450
critical = #FF6E6E
disabled = #140C23

[bar/example]
width = 100%
height = 24pt
radius = 13
monitor = ${env:MONITOR:}

; dpi = 96

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 2pt

border-size = 1pt
border-color = #A88CFF

padding-left = 3
padding-right = 3

module-margin = 0

separator = /
separator-foreground = ${colors.disabled}

font-0 = JetBrainsMono Nerd Font;3
font-1 = FiraCode Nerd Font;3
font-2 = monospace;3
font-3 = Noto Color Emoji;1

modules-left = terminal xworkspaces
modules-right = zapret volume nightmode netspeed memory cpu battery powermenu
modules-center = date

cursor-click = pointer
cursor-scroll = ns-resize

enable-ipc = true

; wm-restack = generic
; wm-restack = bspwm
; wm-restack = i3

; override-redirect = true

[module/systray]
type = internal/tray

format-margin = 3pt
tray-spacing = 6pt

[module/xworkspaces]
type = internal/xworkspaces

label-active-background = ${colors.background-alt}
label-active-underline= ${colors.primary}
label-active-padding = 1

label-occupied = %name%
label-occupied-padding = 1

label-urgent = %name%
label-urgent-background = ${colors.alert}
label-urgent-padding = 1

label-empty = %name%
label-empty-foreground = ${colors.disabled}
label-empty-padding = 1



[module/volume]
type = internal/alsa
devices = default
format-volume = %{A1:pavucontrol:} <label-volume>%{A}
format-muted = %{A1:pavucontrol:}󰝟 <label-muted>%{A}
label-volume = %percentage%%
label-muted = 0%


[module/nightmode]
type = custom/script
exec = ~/.config/polybar/scripts/night_mode.sh
interval = 0.2
format-foreground = ${colors.alert}
click-left = ~/.config/polybar/scripts/toggle_night_mode.sh

[module/powermenu]
type = custom/script
exec = echo 
content-foreground = ${colors.primary}
click-left = rofi -show power-menu -modi "power-menu:rofi-power-menu" -theme ~/.config/rofi/powermenu.rasi

[module/zapret]
type = custom/text
content = %{A1:kitty --hold zapret:}󰈈%{A}
interval = 3

[module/battery]
type = internal/battery
battery = BAT0
adapter = AC
full-at = 98
time-format = %H:%M%
format-charging = <animation-charging> <label-charging>
format-plugged = <label-plugged>
format-alt = <ramp-capacity> <label-alt>
label-charging = %percentage%% %time%
label-plugged = %percentage%%
label-alt = %time%
label-full = %percentage%
label-discharging = %percentage%
ramp-capacity-0 = 󰁺
ramp-capacity-1 = 󰁼
ramp-capacity-2 = 󰁿
ramp-capacity-3 = 󰂂
ramp-capacity-4 = 󰁹
animation-charging-0 = 󰂄
animation-charging-1 = 󰚥
animation-charging-framerate = 1
ramp-capacity-warn = 󰁺
ramp-capacity-cri = 󰚥

[module/netspeed]
type = custom/script
exec = ~/.config/polybar/scripts/network_speed.sh
interval = 1
format = <label>
label = %output%
click-left = kitty --hold sh -lc '~/.config/polybar/scripts/net_speed.sh --watch'

#[module/xkeyboard]
#type = internal/xkeyboardblacklist-0 = num lock

label-layout = %layout%
label-layout-foreground = ${colors.primary}

label-indicator-padding = 2
label-indicator-margin = 1
label-indicator-foreground = ${colors.background}
label-indicator-background = ${colors.secondary}

[module/memory]
type = internal/memory
interval = 2
format-prefix = "  "
format-prefix-foreground = ${colors.primary}
label = %percentage_used:2%%

[module/terminal]
type = custom/text
format-prefix = ""
content = %{A1:kitty &:}%{A}
format-prefix-foreground = ${colors.primary}

[module/cpu]
type = internal/cpu
interval = 2
format-prefix = " "
format-prefix-foreground = ${colors.primary}
label = %percentage:2%%

[module/date]
type = internal/date
interval = 1

date = %H:%M
date-alt = %Y-%m-%d %H:%M:%S

label = %date%
label-foreground = ${colors.primary}

[settings]
screenchange-reload = true
pseudo-transparency = true

; vim:ft=dosini
EOF

cat << 'EOF' > "$HOME/.config/polybar/scripts/net_speed.sh"
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
EOF

cat << 'EOF' > "$HOME/.config/polybar/scripts/network_speed.sh"
#!/bin/bash

# Автоопределение активного интерфейса
interface=$(ip route get 8.8.8.8 2>/dev/null \
  | awk '{for(i=1;i<=NF;i++) if ($i=="dev") {print $(i+1); exit}}')

# Проверка наличия интерфейса
if [ -z "$interface" ] || [ ! -d "/sys/class/net/$interface" ]; then
  echo "нет активного интерфейса"
  exit 0
fi

rx_path="/sys/class/net/$interface/statistics/rx_bytes"
tx_path="/sys/class/net/$interface/statistics/tx_bytes"

# Чтение начальных значений
old_rx=$(< "$rx_path")
old_tx=$(< "$tx_path")

# Интервал измерения (секунды)
interval=1
sleep "$interval"

# Чтение новых значений
new_rx=$(< "$rx_path")
new_tx=$(< "$tx_path")

# Защита от обнуления счётчиков
if [ "$new_rx" -lt "$old_rx" ]; then new_rx=$old_rx; fi
if [ "$new_tx" -lt "$old_tx" ]; then new_tx=$old_tx; fi

# Байты в секунду
rx_bps=$(( (new_rx - old_rx) / interval ))
tx_bps=$(( (new_tx - old_tx) / interval ))

# Функция красивого вывода (KB/s или MB/s)
human_speed() {
  local bps=$1
  if [ "$bps" -lt 1048576 ]; then # < 1 MB/s
    echo $(( bps / 1024 ))"KB/s"
  else
    # вывод с одним знаком после запятой, MB/s
    printf "%.1fMB/s" "$(echo "$bps / 1024 / 1024" | bc -l)"
  fi
}

rx_display=$(human_speed "$rx_bps")
tx_display=$(human_speed "$tx_bps")

echo " $rx_display ↓ ↑ $tx_display"
EOF

cat << 'EOF' > "$HOME/.config/polybar/scripts/toggle_night_mode.sh"
#!/bin/bash
STATE_FILE=~/.cache/nightmode.state

if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE" 2>/dev/null)" = "night" ]; then
    # Выключаем
    pkill -f gammastep 2>/dev/null || true
    xgamma -gamma 1.0 2>/dev/null || true
    echo "day" > "$STATE_FILE"
else
    # Включаем
    gammastep -O 5200 &
    echo "night" > "$STATE_FILE"
fi
EOF

cat << 'EOF' > "$HOME/.config/polybar/scripts/night_mode.sh"
#!/bin/bash
STATE_FILE=~/.cache/nightmode.state
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "night" ]; then
    echo ""  # Луна
else
    echo ""  # Солнце
fi
EOF

cat << 'EOF' > "$HOME/.config/polybar/scripts/mon.sh"
#!/bin/bash

pkill -9 polybar 2>/dev/null || true
killall -q -9 polybar 2>/dev/null || true
sleep 1

# Запускаем на ВСЕХ подключённых мониторах
if type "xrandr" > /dev/null 2>&1; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload example &
    done
else
    polybar --reload example &
fi
EOF

cat << 'EOF' > "$HOME/.config/picom/picom.conf"
backend = "glx";
vsync = true;
EOF

cat << 'EOF' > "$HOME/.config/rofi/config.rasi"
configuration {
    modes: "window,run,ssh,drun";
    sorting-method: "normal";
    show-icons: true;
    matching: "regex";
    drun-match-fields: "name";
    display-run: "Menu:";
    display-ssh: "SSH:";
    display-drun: "Apps:";
    display-window: "Windows:";
}

@theme "theme"

* {
    font: "JetBrains Mono Nerd Font Regular 18";
    background-color: transparent;
    text-color: @fg0;
    margin: 0px;
    padding: 0px;
    spacing: 0px;
}

window {
    location: center;
    width: 800;
    y-offset: -20;
    border-radius: 24px;
    border: 1px;
    border-color: @bg3;
    background-color: @bg0;
}

mainbox {
    padding: 12px;
}

inputbar {
    background-color: @bg1;
    border-color: @bg3;
    border-radius: 16px;
    border: 2px;
    padding: 8px 16px;
    spacing: 8px;
    children: [prompt, entry];
}

prompt {
    text-color: @blue;
}

entry {
    placeholder: "Search";
    placeholder-color: @cyan;
}

message {
    margin: 12px 0 0;
    border-radius: 16px;
    border-color: @bg2;
    background-color: @bg2;
}

textbox {
    padding: 8px 24px;
    background-color: @bg2;
}

listview {
    background-color: transparent;
    margin: 12px 0 0;
    columns: 1;
    lines: 10;
    fixed-height: false;
}

element {
    padding: 8px 16px;
    spacing: 8px;
    border-radius: 16px;
}

element normal urgent {
    text-color: @urgent;
}

element normal active {
    text-color: @accent;
}

element selected normal, element selected active {
    background-color: @bg2;
}

element-icon {
    size: 1em;
    vertical-align: 0.5;
}

element-text {
    text-color: inherit;
}
EOF

cat << 'EOF' > "$HOME/.config/rofi/druncmd"
#!/bin/bash

# Путь к AppImage
BETTERDISCORD="/usr/bin/betterdiscord"

if [ ! -f "$BETTERDISCORD" ]; then
    echo "Error: BetterDiscord not found"
    exit 1
fi

# Запуск
exec "$BETTERDISCORD"
EOF

cat << 'EOF' > "$HOME/.config/rofi/theme.rasi"
* {
    bg0: #333351;
    bg1: #2a2a68;
    bg2: #1e1e38;
    bg3: #2a2a4a;
    fg0: #c3b4f7;
    fg1: #a99edb;
    fg2: #8a82c2;
    red: #e085b0;
    green: #7dc0a0;
    yellow: #e0af68;
    blue: #7aa2f7;
    magenta: #9d7de0;
    cyan: #4abaaf;
    accent: @magenta;
    urgent: @yellow;
}
EOF

cat << 'EOF' > "$HOME/.config/rofi/powermenu.rasi"
* {
    bg0: #333351;
    bg1: #2a2a68;
    bg2: #1e1e38;
    bg3: #2a2a4a;
    fg0: #c3b4f7;
    fg1: #a99edb;
    fg2: #8a82c2;
    red: #e085b0;
    green: #7dc0a0;
    yellow: #e0af68;
    blue: #7aa2f7;
    magenta: #9d7de0;
    cyan: #4abaaf;
    accent: @magenta;
    urgent: @yellow;
}
EOF

cat << 'EOF' > "$HOME/.config/fastfetch/my_logo.txt"

      xx  /\  xx
     x  x/  \x  x
     x  /    \  x
      x/      \x
      /        \
     /  --  --  \
    /     --     \
   /      /\      \
  /      /  \      \
 /      /    \      \
/______/      \______\

______          _______
 _____________________
| +       + -       - |
| ARCH____AAA___LINUX |
|_____________________|
EOF

cat << 'EOF' > "$HOME/.config/kitty/kitty.conf"
# Прозрачность фона
background_opacity 0.85

# Закруглённые углы (в пикселях)
window_border_width 0
macos_titlebar_color system
enable_macos_fullscreen_margin off

# Отключаем рамку
window_padding_width 10 10 10 10

# Скрыть заголовок (опционально — для "безрамочного" вида)
hide_window_decorations yes

# Шрифт (опционально)
font_family JetBrains Mono Nerd Font
bold_font auto
italic_font auto
bold_italic_font auto
font_size 10.0

# Цветовая схема (пример — можно поменять)
foreground #cdd6f4
background #1e1e2e
selection_foreground #cdd6f4
selection_background #45475a
cursor #f5e0dc
# Увеличить шрифт
map ctrl+alt+= increase_font_size

# Уменьшить шрифт
map ctrl+alt+minus decrease_font_size

# Сбросить к исходному размеру
map ctrl+alt+0 reset_font_size
EOF

chmod +x "$HOME/.config/polybar/scripts/"*.sh
chmod +x "$HOME/.config/i3/monic1.sh"
echo -e "${GREEN}Скрипты Polybar сделаны исполняемыми${NC}"
echo -e "${GREEN}Готово!${NC}"
echo -e "${YELLOW}Рекомендуется перезагрузить систему или перезайти в сессию.${NC}"
echo -e "${RED}Внимание: Убедитесь, что установлены все зависимости (polybar, kitty, rofi, grim, playerctl, brightnessctl, nitrogen, picom, i3).${NC}"