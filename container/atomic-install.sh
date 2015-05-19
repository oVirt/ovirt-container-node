#!/usr/bin/bash
# Make th persist directories
echo "Making direcotries"
mkdir -p /host/${CONFDIR}/iscsi

# Create Container
echo "Creating container"
chroot /host /usr/bin/docker create --privileged --net=host --cap-add=ALL -ti \
                                      -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
                                      -v ${CONFDIR}/iscsi:/etc/iscsi:rw \
                                      -v /dev:/dev:rw \
                                      -v /lib/modules:/lib/modules:ro \
                                      -v /etc/sysconfig/network-scripts:/etc/sysconfig/network-scripts:rw \
                                       --name vdsmc \
                                      ${IMAGE}

echo "Install service"
# Install systemd unit file for running container
#we need to create the iscsi initiator name
if [ ! -f "/host/${CONFDIR}/iscsi/initiatorname.iscsi" ]; then
	cat > "/host/${CONFDIR}/iscsi/initiatorname.iscsi" << EOF_iscsi
InitiatorName=$(iscsi-iname)
EOF_iscsi
fi

service_file=vdsmc.service
cp /container/$service_file /host/etc/systemd/system/$service_file
# Enabled systemd unit file
chroot /host /usr/bin/systemctl enable vdsmc.service
chroot /host /usr/bin/systemctl daemon-reload
chroot /host /usr/bin/systemctl start vdsmc