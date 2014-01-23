#!/bin/sh
set -x

sudo sh -c 'cat > /etc/systemd/system/network@.service <<EOF
[Unit]
Description=Network connectivity (%i)
Wants=network.target
Before=network.target
BindsTo=sys-subsystem-net-devices-%i.device
After=sys-subsystem-net-devices-%i.device

[Service]
Type=oneshot
RemainAfterExit=yes
EnvironmentFile=/etc/conf.d/network@%i

ExecStart=/usr/bin/ip link set dev %i up
ExecStart=/usr/bin/ip addr add \${address}/\${netmask} broadcast \${broadcast} dev %i
ExecStart=/usr/bin/ip route add \${route} dev %i

ExecStop=/usr/bin/ip addr flush dev %i
ExecStop=/usr/bin/ip link set dev %i down

[Install]
WantedBy=multi-user.target
EOF'

sudo mkdir -p /etc/conf.d
sudo sh -c 'cat > /etc/conf.d/network@eth1 <<EOF
address=192.168.56.10
netmask=24
broadcast=192.168.56.255
route=192.168.56.0/24
EOF'

sudo systemctl daemon-reload
sudo systemctl enable network@eth1
