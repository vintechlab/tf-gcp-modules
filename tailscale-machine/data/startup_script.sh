#!/usr/bin/env sh

TAISCALED_STATE_FILE=/var/lib/tailscale/tailscaled.state

curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

yes | apt-get update  -o DPkg::Lock::Timeout=600
yes | apt-get install -o DPkg::Lock::Timeout=600 tailscale ufw nginx


# Tailscale configuration
mkdir -pv /var/lib/tailscale
echo '${tailscaled_state}' > /var/lib/tailscale/tailscaled.state
chmod 600 /var/lib/tailscale/tailscaled.state
if grep -qs ^foo$ /var/lib/tailscale/tailscaled.state; then
    rm -fv /var/lib/tailscale/tailscaled.state
else
    echo "USE EXISTING TAISCALED PROFILE"
fi

hostname ${machine_name}
echo 127.0.0.1 ${machine_name} >> /etc/hosts
hostname -f > /etc/hostname

ufw allow from 0.0.0.0/0 to any port 22 proto tcp
echo Y | ufw enable

echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

systemctl enable --now tailscaled
systemctl restart tailscaled

