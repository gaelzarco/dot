#!/usr/bin/env bash
set -euo pipefail

# Optional: host overrides via env
: "${MY_SSH_PORT:=22}"

sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow "${MY_SSH_PORT}/tcp"
sudo ufw allow 5353/udp               # mDNS
sudo ufw allow 5900/tcp               # VNC example
sudo ufw allow 6000:7000/udp          # RAOP example
sudo ufw allow 7000/tcp               # RAOP control
# Example of scoped rule (put CIDRs in a private env file if sensitive)
# sudo ufw allow from 10.0.0.0/24 to any port 22 proto tcp

sudo ufw enable
sudo ufw status verbose
