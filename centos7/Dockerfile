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
ADD repo/repo-install.sh /container/
RUN chmod +x /container/repo-install.sh ;/container/repo-install.sh
RUN yum -y install vdsm vdsm-cli && yum clean all; \
 	rm -rf /etc/sysconfig/network-scripts/ifcfg-*; \
 	systemctl enable vdsmd
# VDSM installed

# Prefetching host deploy requirments
RUN yum install -y tuned kexec-tools iptables-services && yum clean all

# Container install section
ADD container/* /container/
RUN chmod +x /container/*.sh ;

# Create place for iscsi initiator name
RUN mkdir -p /etc/iscsi;

LABEL INSTALL='docker run --rm --privileged -v /:/host -e HOST=/host -e CONFDIR=${CONFDIR} -e DATADIR=${DATADIR} -e IMAGE=IMAGE -e NAME=NAME IMAGE /container/atomic-install.sh;'
LABEL UNINSTALL='docker run --rm --privileged -v /:/host -e HOST=/host -e CONFDIR=${CONFDIR} -e DATADIR=${DATADIR} -e IMAGE=IMAGE IMAGE /container/atomic-uninstall.sh'

CMD ["/usr/sbin/init"]
