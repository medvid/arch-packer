#!/bin/sh
set -x

cat > /etc/netctl/eth1 << EOF
Description='Host-only ethernet'
Interface=eth1
Connection=ethernet
IP=static
Address=('192.168.56.10/24')
IP6=no
EOF

netctl enable eth1
