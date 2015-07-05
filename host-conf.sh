#!/usr/bin/env bash

# Upgrades firmwares and packages
rpi-update && reboot
apt-get update && apt-get dist-upgrade

# Installs pulseaudio. Duh.
apt-get install pulseaudio

# Makes PulseAudio start on boot and enables dynamic module loading
sed -i "s/PULSEAUDIO_SYSTEM_START=0/PULSEAUDIO_SYSTEM_START=1/" /etc/default/pulseaudio
sed -i "s/DISALLOW_MODULE_LOADING=1/DISALLOW_MODULE_LOADING=0/" /etc/default/pulseaudio

# Disables timer based scheduling to prevent stutter. See
# https://dbader.org/blog/crackle-free-audio-on-the-raspberry-pi-with-mpd-and-pulseaudio
# https://fedoraproject.org/wiki/How_to_debug_PulseAudio_problems
sed -i "s/load-module module-udev-detect/load-module module-udev-detect tsched=0/" /etc/pulse/system.pa

# Enables the network sink
echo "### Enable network sink" >> /etc/pulse/system.pa
echo "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1;172.17.0.0/16" >> /etc/pulse/system.pa

# Makes sure root can use pulseaudio for debugging purposes etc.
adduser root pulse-access
