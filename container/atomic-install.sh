#!/usr/bin/bash -x
# Make th persist directories
# Create Container
echo "Creating container"
# check for real container
# this container is a singleton

function CreateContainer()
{
	#create the real container
	chroot /host /usr/bin/docker create --privileged --net=host --cap-add=ALL -ti \
                                      -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
                                      -v /dev:/dev:rw \
                                      -v /lib/modules:/lib/modules:ro \
                                      -v /etc/sysconfig/network-scripts:/etc/sysconfig/network-scripts:rw \
                                      -v /${CONFDIR}:/etc:rw \
                                      -v /${DATADIR}:/var:rw \
                                       --name ${NAME} \
                                      ${IMAGE}
}

function install()
{
	echo "Installing"
	echo "Making direcotries"
	mkdir -p /host/${CONFDIR}
	mkdir -p /host/${DATADIR}
	#creating the container
	CreateContainer
    #setting up the persistance images and copying the data in
    echo  "Copying config and data"
    cp -r /etc/* /host/${CONFDIR}
    cp -r /var/* /host/${DATADIR}
}

function upgrade()
{
	echo "Upgrading"
	#creating the container
	CreateContainer
}

#TODO : add resinstall function
#lets see if we upgrading
if [ ! -f /host/${CONFDIR}/vdsm/vdsm.conf ]; then
	install
else
	upgrade
fi

service_file=vdsmc.service
cp /container/$service_file /host/etc/systemd/system/$service_file
# Enabled systemd unit file
chroot /host /usr/bin/systemctl enable vdsmc.service
chroot /host /usr/bin/systemctl daemon-reload
chroot /host /usr/bin/systemctl start vdsmc