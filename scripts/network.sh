#!/bin/sh
set -x

vagrant_dir=/vagrant/files
net_dev=eth1

if [ ! -d /sys/class/net/$net_dev ]; then
  echo "Device $net_dev not found"
  return
elif [ `cat /sys/class/net/$net_dev/operstate` = "up" ]; then
  # link is already up, store current settings
  net_addr=$(ip addr show dev $net_dev | grep -m 1 "inet " | awk '{split($2,a,"/"); print a[1]}')
  net_mask=$(ip addr show dev $net_dev | grep -m 1 "inet " | awk '{split($2,a,"/"); print a[2]}')
  net_brd=$(ip addr show dev $net_dev | grep -m 1 "inet " | awk '{print $4}')
  net_route=$(ip route show dev $net_dev | head -1 | awk '{print $1}')
else
  # set default settings
  net_addr="192.168.56.10"
  net_mask="24"
  net_brd="192.168.56.255"
  net_route="192.168.56.0/24"
fi

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
sudo sh -c 'cat > /etc/conf.d/network@$net_dev <<EOF
address=$net_addr
netmask=$net_mask
broadcast=$net_brd
route=$net_route
EOF'

sudo systemctl daemon-reload
sudo systemctl enable network@$net_dev
