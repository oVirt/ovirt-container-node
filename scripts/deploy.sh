#!/bin/sh

sleep 10
# waiting until vdsmd is up.. better to check service status before running
ip link set eth0 down
ip link set eth0 name veth_name0
ip link set veth_name0 up
ip route add default via 10.32.0.1 dev veth_name0
#

python /root/add_network.py

vdsm-tool register --engine-fqdn ovirt-engine --check-fqdn false
