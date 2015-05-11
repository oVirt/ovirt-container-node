#!/usr/bin/bash
# Make th persist directories
# remove systemd unit file
chroot /host /usr/bin/systemctl stop vdsmc.service
chroot /host /usr/bin/systemctl disable vdsmc.service
rm -rf /host/etc/systemd/system/$service_file
chroot /host /usr/bin/systemctl daemon-reload