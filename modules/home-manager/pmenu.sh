#!/bin/bash
SELECTION=$(printf "Lock\nSuspend\nLog out\nReboot\nShutdown" | fuzzel --dmenu -p "Power:")
case $SELECTION in
  "Lock") swaylock ;;
  "Suspend") systemctl suspend ;;
  "Log out") swaymsg exit ;; # Replace with hyprctl dispatch exit if using Hyprland
  "Reboot") systemctl reboot ;;
  "Shutdown") systemctl poweroff ;;
esac 
