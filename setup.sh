#!/usr/bin/env bash
set -euo pipefail

content=https://raw.githubusercontent.com/chpatton013/pi-hole-setup/master

function download_and_copy() {
  local resource destination
  resource="$1"
  destination="$2"
  readonly resource destination

  wget --ouptut-document="./$resource" "$content/$resource"
  sudo cp "./$resource" "$destination"
}

# Interactive steps.
passwd
sudo raspy-config

# Unattended upgrades.
sudo apt-get update
sudo apt-get --assume-yes install unattended-upgrades apt-listchanges
download_and_copy auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades
download_and_copy unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
sudo unattended-upgrade --debug

# Pi Hole setup.
wget --output-document=./pi-hole-install.sh https://install.pi-hole.net
chmod +x ./pi-hole-install.sh
sudo ./pi-hole-install.sh
