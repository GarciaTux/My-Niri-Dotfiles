

set -u

# Fuzzel without the search bar. Optional style file: ~/.config/fuzzel/powermenu.ini
ARGS=(--dmenu --hide-prompt --width 16 --lines 5)
CONF="$HOME/.config/fuzzel/powermenu.ini"
[[ -f "$CONF" ]] && ARGS+=(--config "$CONF")

menu() { fuzzel "${ARGS[@]}"; }

confirm() {
    [[ $(printf '  Yes\n✖  No\n' | menu) == "  Yes" ]]
}

lock_screen() {
    for locker in swaylock hyprlock gtklock; do
        command -v "$locker" >/dev/null && { "$locker"; return; }
    done
    notify-send "Power menu" "No screen locker found."
}

choice=$(printf '%s\n' \
    "🐚  Lock" \
    "🦀  Logout" \
    "🐋  Sleep" \
    "🌊  Restart" \
    "🐙  Shutdown"| menu) || exit 0

case "$choice" in
    *Lock)     lock_screen ;;
    *Logout)   confirm && niri msg action quit --skip-confirmation ;;
    *Sleep)    systemctl suspend ;;
    *Restart)  confirm && systemctl reboot ;;
    *Shutdown) confirm && systemctl poweroff ;;
esac
