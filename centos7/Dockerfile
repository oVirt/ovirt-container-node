FROM centos:7
MAINTAINER "Tolik Litovsky" <tlitovsk@redhat.com>
ENV container docker

RUN yum -y update; yum clean all;
RUN yum -y install yum-utils

# Libvirt install section libvirt install
# fix language
RUN yum -y install libvirt-daemon-driver-* libvirt-daemon libvirt-daemon-kvm qemu-kvm  qemu-kvm-tools  && yum clean all; \
	localedef -i en_US -c -f UTF-8 en_US.UTF-8 ;\
	systemctl enable libvirtd
VOLUME [ "/sys/fs/cgroup" ]
# libvirt installed

# VDSM install
RUN mkdir /container
ADD container/repo-install.sh /container/
RUN chmod +x /container/repo-install.sh ;/container/repo-install.sh
RUN yum -y install vdsm vdsm-cli && yum clean all; \
 	rm -rf /etc/sysconfig/network-scripts/ifcfg-*; \
 	systemctl enable vdsmd
VOLUME ["/etc/sysconfig/network-scripts/"]
# VDSM installed

# Prefetching host deploy requirments
RUN yum install -y tuned kexec-tools iptables-services && yum clean all

# Udev install and fixup
# udev must be latest package installed to able to fix all rules
# lvm2 fixup
# udev enabling until the great 7.2 arrive
RUN sed -i 's/IMPORT{builtin}=\"blkid/IMPORT{program}=\"\/usr\/sbin\/blkid'/ /usr/lib/udev/rules.d/*; \
	ln -s /lib/systemd/system/systemd-udevd-control.socket /lib/systemd/system/sockets.target.wants/systemd-udevd-control.socket; \
	ln -s /lib/systemd/system/systemd-udevd-kernel.socket /lib/systemd/system/sockets.target.wants/systemd-udevd-kernel.socket; \
	ln -s /lib/systemd/system/systemd-udev-trigger.service /lib/systemd/system/sysinit.target.wants/systemd-udev-trigger.service; \
	ln -s /lib/systemd/system/systemd-udevd.service /lib/systemd/system/sysinit.target.wants/systemd-udevd.service;
VOLUME ["/etc/iscsi/"]
VOLUME ["/dev"]
# udev installed


# Container install section
ADD container/* /container/
RUN chmod +x /container/* ;

# Create place for iscsi initiator name
RUN mkdir -p /etc/iscsi;

LABEL INSTALL='docker run --rm --privileged -v /:/host -e HOST=/host -e CONFDIR=${CONFDIR} -e IMAGE=IMAGE --name NAME IMAGE /container/atomic-install.sh;'
LABEL UNINSTALL='docker run --rm --privileged -v /:/host -e HOST=/host -e CONFDIR=${CONFDIR} -e IMAGE=IMAGE --name NAME IMAGE /container/atomic-uninstall.sh'

CMD ["/usr/sbin/init"]
