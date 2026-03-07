#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Начало установки конфигурации Hyprland...${NC}"

# 1. Создание базовой структуры директорий
echo -e "${YELLOW}Создание директорий...${NC}"
mkdir -p "$HOME/.config/hypr"
mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.config/waybar/scripts"
mkdir -p "$HOME/.config/wlogout"
mkdir -p "$HOME/.config/fastfetch"
mkdir -p "$HOME/.config/rofi"
mkdir -p "$HOME/.config/mako"
mkdir -p "$HOME/Pictures/Wallpapers"
mkdir -p "$HOME/Pictures/Screenshots"

# Функция для создания резервной копии
backup_file() {
    if [ -f "$1" ]; then
        cp "$1" "${1}.bak.$(date +%F_%H-%M-%S)"
        echo -e "${YELLOW}Бэкап создан: ${1}.bak...${NC}"
    fi
}

# ==============================================================================
# 2. HYPRLAND CONFIG
# ==============================================================================
echo -e "${YELLOW}Настройка Hyprland...${NC}"
backup_file "$HOME/.config/hypr/hyprland.conf"

cat << 'EOF' > "$HOME/.config/hypr/hyprland.conf"
#monitors
source = ~/.config/hypr/monitors.conf
#debug:overlay = true
#misc {
#    vfr = false
#}
#opengl {
#    nvidia_anti_flicker = true
#}
#cursor {
#    use_cpu_buffer = 2
#}
render = explicit_sync, 0
render = explicit_sync_kms, 0
env = XDG_SESSION_TYPE,wayland
env = XDG_CURRENT_DESKTOP,Hyprland
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
#env = WLR_DRM_NO_MODIFIERS,1
env = GBM_BACKEND,nvidia-drm
##env = WLR_DRM_NO_ATOMIC,1
env = HYPRCURSOR_THEME, ArcMidnight-Cursors
env = HYPRCURSOR_SIZE, 24
env = XDG_RUNTIME_DIR, /run/user/$UID
env = DBUS_SESSION_BUS_ADDRESS,unix:path=/run/user/$UID/bus#MODIFICATOR (WIN KEY)
env = GDK_SCALE,1
env = GDK_DPI_SCALE,1
env = QT_SCALE_FACTOR,1
#env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORMTHEME,qt6ct
env = QT_QPA_PLATFORM,wayland;xcb
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
env = QT_STYLE_OVERRIDE,kvantum
env = QT_QPA_PLATFORM_FALLBACK,xcb
env = GDK_BACKEND,wayland,x11
env = ELECTRON_ENABLE_WAYLAND,1
env = GDK_SCALE,1
env = FREETYPE_PROPERTIES,"truetype:interpreter-version=40"
env = QT_ENABLE_HIGHDPI_SCALING,1
env = QT_FONT_DPI,96
env = XCURSOR_THEME, ArcMidnight-cursors
env = XCURSOR_SIZE, 24
env=VSYNC,1

#MODIFICATOR (WIN KEY)
$mod = SUPER
$mod1 = ALT
$TERMINAL = kitty
$BROWSER = firefox
$FILE_MANAGER = thunar

#(config)
bind = $mod1, L, exec, wlogout -l ~/.config/wlogout/layout -C ~/.config/wlogout/style.css
#bind = $mod1, ESCAPE, exec, hyprlock
#bind = $mod1, ESCAPE, exec, ~/.config/hypr/lock.sh
#bind = $mod1, ESCAPE, exec, wlogout --button-lock-command ~/.config/wlogout/lock.sh
bind = $mod1, RETURN, exec, kitty --class=fastfetch-terminal -e bash -c "fastfetch --file ~/.config/fastfetch/my_logo.txt; exec bash"
bind = $mod, RETURN, exec, kitty
bind = $mod, Q, killactive,
bind = $mod, M, exec, rofi -show drun -show-icons -config ~/.config/rofi/config.rasi
bind = $mod, E, exec, $FILE_MANAGER
bind = $mod, J, focuswindow, next
bind = $mod, K, focuswindow, prev
bind = $mod, V, togglefloating
bind = $mod, F, fullscreen,
bindm = $mod, mouse:272, movewindow
bindm = $mod, mouse:273, resizewindow
bindm = $mod, mouse:274, resizewindow
bindm = $mod, mouse:273, resizeactive
bindm = $mod, mouse:272, swapwindow

#resizing
bind = $mod, Up, resizeactive, 100 100
bind = $mod, Down, resizeactive, -100 -100
bind = $mod, Left, resizeactive, -100 100
bind = $mod, Right, resizeactive, 100 -100

#Windows moving
bind = $mod, A, movetoworkspace, -1
bind = $mod SHIFT, A, movetoworkspace, +1

#WORK TABLES
bind = $mod, 1, workspace, 1 
bind = $mod, 2, workspace, 2
bind = $mod, 3, workspace, 3
bind = $mod, 4, workspace, 4
bind = $mod, 5, workspace, 5
bind = $mod SHIFT, 1, movetoworkspace, 1
bind = $mod SHIFT, 2, movetoworkspace, 2
bind = $mod SHIFT, J, swapwindow, next
bind = $mod SHIFT, K, swapwindow, prev
bind = $mod SHIFT, 3, movetoworkspace, 3
bind = $mod SHIFT, 4, movetoworkspace, 4
bind = $mod SHIFT, 5, movetoworkspace, 5
#FOR COPY on future
#bind = $mod,
#bind = $mod,
#bind = $mod,
decoration {
    rounding = 16
}

#bezier = smooth, 0.0, 0.0, 0.25, 1.0
#animation = windows, 1, 8, smooth, slide
#animation = fadeIn, 1, 10, smooth
#animation = fadeOut, 1, 10, smooth


#AUTORUN
#On start
exec-once = kanshi
#exec-once = hyprctl setcursor ArcMidnght-cursors 24
#exec-once = hyprpaper
exec-once = swaybg -i ~/Pictures/Wallpapers/ku.jpg -m fill
#exec-once = hyprlock
exec-once = blueman-applet
exec-once = waybar -c ~/.config/waybar/config.json -s ~/.config/waybar/style.css
exec-once = mako
exec-once = bluetoothctl
exec-once = dbus-launch --session polkit-gnome-authentication-agent-1
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = systemctl --user start wireplumber &
exec-once = sleep 2 && systemctl --user start pipewire-pulse &
#exec-once = sleep 3 && pavucontrol
#exec-once = pipewire &
#exec-once = pipewire-pulse &
#exec-once = wireplumber &
exec-once = alsa-restore-service &
exec-once = xdg-desktop-portal-hyprland
exec-once = xdg-desktop-portal
#exec-once = /usr/lib/xdg-desktop-portal-hyprland
#exec-once = /usr/lib/xdg-desktop-portal -r
exec-once = dbus-launch
#exec-once = pulseaudio --start
#exec-once = systemctl --user start pipewire.service
#exec-once = systemctl --user start wireplumber.service
exec-once = systemctl --user import-environment XDG_CURRENT_DESKTOP
exec-once = systemctl --user start chronyd
#brightness
bind = $mod SHIFT, K, exec, brightnessctl set 10%+
bind = $mod SHIFT, L, exec, brightnessctl set 10%-
bind = $mod, F1, exec, brightnessctl set 5%+
bind = $mod, F2, exec, brightnessctl set 5%-

#Sound
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle
bind = $mod SHIFT, F, exec, wpctl set-volume @DEFAULT_SINK@ 5%+
bind = $mod SHIFT, E, exec, wpctl set-volume @DEFAULT_SINK@ 5%-
bind = $mod SHIFT, W, exec, wpctl set-mute @DEFAULT_SINK@ toggle
bind = $mod SHIFT, C, exec, pavucontrol

#Media
bind = , XF86AudioPlay, exec, sh -c 'playerctl play-pause'
bind = , XF86AudioNext, exec, sh -c 'playerctl next'
bind = , XF86AudioPrev, exec, sh -c 'playerctl previous'

#Screenshots and blocking
bind = , XF86ScreenSaver, exec, grim ~/Pictures/Screenshots/$(date '+%Y-%m-%d-%H-%M-%S').png
bind = $mod SHIFT, S, exec, grim -g "$(slurp)" - | wl-copy
bind = $mod SHIFT, L, exec, sh -c 'swaylock \
  --image ~/Pictures/lock.jpg \
  --scaling full \
  --effect-blur 15x15 \
  --effect-scale 1.5 \
  --fade-in 1 \
  --ring-color bb00cc \
  --key-hl-color 00ffff \
  --text-color ffffff \
  --indicator-radius 100 \
  --indicator-tickness 7 \
  --grace 2 \
  --ignore-empty-password'
bind = $mod SHIFT, R, exec, pkill -USR2 -x Hyprland

input {
    kb_layout = us,ru
    kb_options = grp:win_space_toggle
}
EOF

# Мониторы
cat << 'EOF' > "$HOME/.config/hypr/monitors.conf"
#monitor=HDMI-A-1,1920x1080@60.0,2400x0,0.6
#monitor=DP-1,1920x1080@59.94,0x0,0.7999999999999999
monitor=eDP-1,1920x1080@60.03,0x0,1.0
EOF

# Hyprlock
cat << 'EOF' > "$HOME/.config/hypr/hyprlock.conf"
# Общий фон
background {
    monitor =
    path = ~/Pictures/Wallpapers/pcpict.jpg
    color = rgba(22, 22, 36, 1.0)
    blur_passes = 3
    blur_size = 8
    vibrancy = 0.15
    vibrancy_darkness = 0.05
}

# Поле ввода
input-field {
    monitor =
    size = 40%, 8%
    outline_thickness = 3
    inner_color = rgba(0, 0, 0, 0.0)
    outer_color = rgba(93, 125, 224, 1.0)
    check_color = rgba(125, 192, 160, 1.0)
    fail_color = rgba(224, 133, 176, 1.0)
    font_color = #c3b4f7
    font_family = JetBrainsMono Nerd Font
    fade_on_empty = false
    rounding = 12
    position = 0, -100
    halign = center
    valign = center
    placeholder_text = PASSWORD
}


# Часы
label {
    monitor =
    text = cmd[update:1000] date +"%H:%M:%S"
    color = #c3b4f7
    font_size = 24
    font_family = JetBrainsMono Nerd Font
    position = 0, 100
    halign = center
    valign = center
}
# Дата
label {
    monitor =
    text = cmd[update:5000] date +"%A, %d %B %Y"
    color = #9d7de0
    font_size = 14
    font_family = JetBrainsMono Nerd Font
    position = 0, 140
    halign = center
    valign = center
}

# Раскладка
label {
    monitor =
    text = $LAYOUT
    color = #7dc0a0
    font_size = 12
    font_family = JetBrainsMono Nerd Font
    position = 0, 180
    halign = center
    valign = center
}
EOF

# Hyprpaper
cat << 'EOF' > "$HOME/.config/hypr/hyprpaper.conf"
# Предзагрузка изображения
preload = ~/Pictures/Wallpapers/pcpict.jpg

# Установка обоев для всех мониторов
wallpaper = ,~/Pictures/Wallpapers/pcpict.jpg

#stretch = true
EOF

# ==============================================================================
# 3. KITTY CONFIG
# ==============================================================================
echo -e "${YELLOW}Настройка Kitty...${NC}"
backup_file "$HOME/.config/kitty/kitty.conf"

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

# ==============================================================================
# 4. WAYBAR CONFIG
# ==============================================================================
echo -e "${YELLOW}Настройка Waybar...${NC}"
backup_file "$HOME/.config/waybar/style.css"
backup_file "$HOME/.config/waybar/config.json"

cat << 'EOF' > "$HOME/.config/waybar/style.css"
/* Тёмно-фиолетовая, мягкая, полупрозрачная тема */
* {
  font-family: "JetBrainsMono Nerd Font", "FiraCode Nerd Font", monospace;
  font-size: 12pt;
}

@define-color bg rgba(20, 12, 35, 0.40);      /* основной фон: тёмно-фиолетовый, прозрачный */
@define-color bg-hover rgba(32, 18, 55, 0.55);
@define-color bg-active rgba(60, 30, 95, 0.70);
@define-color fg #C4B0D8;                     /* светло-лиловый текст */
@define-color accent #A88CFF;                 /* акцент */
@define-color warn #E6B450;                   /* предупреждения */
@define-color crit #FF6E6E;                   /* критичное */

window#waybar {
  background: @bg; 
  color: @fg;
}

/* общая “капсула” для модулей */
#waybar > box {
  background: @bg;
  border: 1px solid rgba(168, 140, 255, 0.25);
  border-radius: 18px;
  padding: 4px 8px;
  margin: 0 6px;
  box-shadow: 0 6px 22px rgba(5, 0, 20, 0.35);
}

/* кнопки рабочих столов */
#workspaces button {
  color: @fg;
  background: transparent;
  border-radius: 14px;
  padding: 2px 10px;
  margin: 2px 4px;
  transition: 150ms ease;
}
#workspaces button:hover { background: @bg-hover; }
#workspaces button.active { background: @bg-active; color: white; }
#workspaces button.urgent { background: @crit; color: #10091A; }

/* отступы/пилюли для каждого виджета */
#clock,
#pulseaudio,
#custom-notifications,
#cpu,
#memory,
#battery,
#custom-terminal,
#custom-zapret,
#custom-network_speed,
#custom-nightmode,
#custom-wlogout {
  padding: 4px 10px;
  margin: 0 4px;
  background: rgba(0,0,0,0.10);
  border-radius: 14px;
}

/* ховеры */
#clock:hover,
#pulseaudio:hover,
#custom-notifications:hover,
#cpu:hover,
#memory:hover,
#battery:hover,
#custom-terminal:hover,
#custom-zapret:hover,
#custom-network_speed:hover,
#custom-nightmode:hover,
#custom-wlogout:hover {
  background: @bg-hover;
}

/* активные/кликаемые */
#custom-terminal:active,
#custom-zapret:active,
#pulseaudio:active,
#custom-nightmode:active,
#custom-wlogout:active {
  background: @bg-active;
}

/* цвета для состояний батареи */
#battery.warning { color: @warn; }
#battery.critical { color: @crit; animation: blink 1s steps(1) infinite; }
@keyframes blink { 50% { color: rgba(255,255,255,0.6); } }

/* звук — приглушённый */
#pulseaudio.muted { opacity: 0.6; }

/* всплывающие подсказки */
tooltip {
  background: rgba(20, 12, 35, 0.9);
  border: 1px solid rgba(168, 140, 255, 0.3);
  border-radius: 10px;
  box-shadow: 0 10px 30px rgba(5, 0, 20, 0.5);
}
tooltip label { color: @fg; }

/* колокольчик уведомлений */
#custom-notifications { color: @accent; }

/* часы в центре чуть крупнее */
#clock { font-weight: 600; letter-spacing: 0.3px; }

/* аккуратные разделители */
#waybar separator { color: rgba(218, 212, 234, 0.25); }
EOF

cat << 'EOF' > "$HOME/.config/waybar/config.json"
{
  "layer": "top",
  "position": "top",
  "height": 42,
  "margin-top": 6,
  "margin-left": 10,
  "margin-right": 10,

  "modules-left": [
    "custom/terminal",
    "hyprland/workspaces"
  ],

  "modules-center": [
    "clock"
  ],

  "modules-right": [
    "custom/zapret",
    "pulseaudio",
    "custom/network_speed",
    "custom/notifications",
    "custom/nightmode",
    "cpu",
    "memory",
    "custom/wlogout",
    "battery"
  ],

  "hyprland/workspaces": {
    "all-outputs": true,
    "disable-scroll": false,
    "format": "{name}",
    "on-click": "activate",
    "sort-by-number": true
  },

  "clock": {
    "format": "{:%H:%M}",
    "tooltip-format": "{:%A, %d %B %Y}",
    "interval": 1,
    "on-click": "kitty --hold cal"
  },

  "custom/terminal": {
    "format": "",
    "tooltip": "Открыть терминал (kitty)",
    "on-click": "kitty",
    "signal": 1
  },

  "custom/zapret": {
    "format": "🛡",
    "tooltip": "Запустить zapret в терминале",
    "on-click": "kitty --hold zapret"
  },

  "pulseaudio": {
    "format": "{icon} {volume}%",
    "format-muted": "󰝟 0%",
    "format-icons": {
      "headphones": "",
      "default": ["","",""]
    },
    "scroll-step": 3,
    "on-click": "pavucontrol"
  },

  "custom/network_speed": {
    "exec": "~/.config/waybar/scripts/network_speed.sh",
    "interval": 1,
    "format": "{}",
    "tooltip": "Скорость сети (вход/выход)",
    "on-click": "kitty --hold sh -lc '~/.config/waybar/scripts/network_speed.sh --watch'"
  },

  "custom/notifications": {
    "format": " ",
    "tooltip": false,
    "on-click": "makoctl dismiss -a"
  },

  "custom/nightmode": {
    "exec": "~/.config/waybar/scripts/night_mode.sh",
    "interval": 5,
    "format": "{}",
    "tooltip": "Ночной режим (лкм — переключить)",
    "on-click": "~/.config/waybar/scripts/toggle_night_mode.sh"
  },

  "cpu": {
    "format": " {usage}%",
    "tooltip": true,
    "interval": 2
  },

  "memory": {
    "format": " {percentage}%",
    "interval": 3,
    "tooltip": true
  },

  "custom/wlogout": {
    "format": "",
    "tooltip": "wlogout",
    "on-click": "wlogout"
  },

  "battery": {
    "format": "{capacity}% {icon}",
    "format-charging": "{capacity}% 󰂄",
    "format-plugged": "{capacity}% 󰚥",
    "format-alt": "{time} {icon}",
    "states": {
      "warning": 25,
      "critical": 10
    },
    "format-icons": ["󰁺","󰁼","󰁿","󰂂","󰁹"],
    "tooltip": true,
    "interval": 10
  }
}
EOF

# Скрипты Waybar

cat << 'EOF' > "$HOME/.config/waybar/scripts/night_mode.sh"
#!/bin/bash
# Проверяет, запущен ли wlsunset
if pgrep -x "wlsunset" > /dev/null; then
    echo ""  # Луна — включено
else
    echo ""  # Солнце — выключено
fi
EOF
cat << 'EOF' > "$HOME/.config/waybar/scripts/net_speed.sh"
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

cat << 'EOF' > "$HOME/.config/waybar/scripts/network_speed.sh"
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

cat << 'EOF' > "$HOME/.config/waybar/scripts/toggle_night_mode.sh"
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
EOF

# ✅ КРИТИЧЕСКИ ВАЖНО: Делаем скрипты исполняемыми
chmod +x "$HOME/.config/waybar/scripts/"*.sh
echo -e "${GREEN}Скрипты Waybar сделаны исполняемыми${NC}"

# ==============================================================================
# 5. WLOGOUT CONFIG ()
# ==============================================================================
echo -e "${YELLOW}Настройка Wlogout...${NC}"
backup_file "$HOME/.config/wlogout/layout"

cat << 'EOF' > "$HOME/.config/wlogout/layout"
{
    "label" : "lock",
    "action" : "hyprlock",
    "text" : "Блокировка",
    "keybind" : "l"
},
{
    "label" : "logout",
    "action" : "loginctl terminate-user $USER",
    "text" : "Выход",
    "keybind" : "e"
},
{
    "label" : "shutdown",
    "action" : "systemctl poweroff",
    "text" : "Выключение",
    "keybind" : "s"
},
{
    "label" : "suspend",
    "action" : "systemctl suspend",
    "text" : "Сон",
    "keybind" : "u"
},
{
    "label" : "reboot",
    "action" : "systemctl reboot",
    "text" : "Перезагрузка",
    "keybind" : "r"
},
{
    "label" : "hibernate",
    "action" : "systemctl hibernate",
    "text" : "Гибернация",
    "keybind" : "h"
}
EOF

cat << 'EOF' > "$HOME/.config/wlogout/style.css"
* {
    background-image: none;
    box-shadow: none;
}

window {
    background-color: rgba(12, 12, 12, 0.9);
}

button {
    border-radius: 12px;
    border-color: #3b4252;
    text-decoration-color: #ffffff;
    color: #ffffff;
    background-color: #2e3440;
    border-style: solid;
    border-width: 2px;
    background-repeat: no-repeat;
    background-position: center;
    background-size: 25%;
    margin: 10px;
}

button:focus, button:active, button:hover {
    background-color: #3b4252;
    outline-style: none;
}

#lock {
    background-image: image(url("icons/lock.png"), url("/usr/share/wlogout/icons/lock.png"));
}

#logout {
    background-image: image(url("icons/logout.png"), url("/usr/share/wlogout/icons/logout.png"));
}

#shutdown {
    background-image: image(url("icons/shutdown.png"), url("/usr/share/wlogout/icons/shutdown.png"));
}

#suspend {
    background-image: image(url("icons/suspend.png"), url("/usr/share/wlogout/icons/suspend.png"));
}

#reboot {
    background-image: image(url("icons/reboot.png"), url("/usr/share/wlogout/icons/reboot.png"));
}

#hibernate {
    background-image: image(url("icons/hibernate.png"), url("/usr/share/wlogout/icons/hibernate.png"));
}
EOF

# ==============================================================================
# 6. FASTFETCH & ROFI
# ==============================================================================
echo -e "${YELLOW}Настройка Fastfetch и Rofi...${NC}"

cat << 'EOF' > "$HOME/.config/fastfetch/my_logo.txt"
        /\  
       /  \
      /    \  
     /      \
    /        \
   /  --  --  \
  /     --     \
 /      /\      \
/______/  \______\

EOF

backup_file "$HOME/.config/rofi/config.rasi"
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

# ==============================================================================
# ЗАВЕРШЕНИЕ
# ==============================================================================
echo -e "${GREEN}Готово!${NC}"
echo -e "${YELLOW}Рекомендуется перезагрузить систему или перезайти в сессию.${NC}"
echo -e "${RED}Внимание: Убедитесь, что установлены все зависимости (waybar, kitty, rofi, wlogout, grim, slurp, swaylock, playerctl, brightnessctl).${NC}"