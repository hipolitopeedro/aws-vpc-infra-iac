#!/usr/bin/env bash
# ==============================================================================
# Script: user-data-bootstrap.sh
# EN: EC2 Linux User Data script for OS patching, SSH hardening, and NGINX setup.
# PT: Script User Data EC2 Linux para atualização do SO, hardening SSH e NGINX.
# ==============================================================================

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

# 1. Update packages
if command -v dnf >/dev/null 2>&1; then
    dnf update -y
    dnf install -y nginx fail2ban
elif command -v apt-get >/dev/null 2>&1; then
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y nginx fail2ban
fi

# 2. Harden SSH daemon configuration
SSHD_CONFIG="/etc/ssh/sshd_config"
if [[ -f "$SSHD_CONFIG" ]]; then
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
    sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
    systemctl restart sshd || systemctl restart ssh
fi

# 3. Enable and start services
systemctl enable --now fail2ban
systemctl enable --now nginx

cat << 'EOF' > /usr/share/nginx/html/healthz
OK
EOF
