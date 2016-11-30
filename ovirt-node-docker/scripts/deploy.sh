#!/bin/sh

# waiting until vdsmd is up.. better to check service status before running
sleep 10
python /root/add_network.py
