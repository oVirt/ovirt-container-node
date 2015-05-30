#!/usr/bin/bash
# remove systemd unit file
service_file=vdsmc.service
chroot /host /usr/bin/systemctl stop $service_file
chroot /host /usr/bin/systemctl disable $service_file
rm -rf /host/etc/systemd/system/$service_file
chroot /host /usr/bin/systemctl daemon-reload