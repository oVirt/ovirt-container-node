FROM centos:7
MAINTAINER "Yaniv Bronhaim" <ybronhei@redhat.com>
ENV container docker

RUN echo "root:ovirt-node" | chpasswd
RUN echo "options kvm-intel nested=1" > /etc/modprobe.d/kvm-intel.conf
RUN ln -s ../boot/grub2/grub.cfg /etc/grub2.cfg

# copied from http://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/
RUN yum -y update; yum clean all
RUN yum -y install systemd; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]
# http://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/

# copied from ovirt-container-node
RUN yum -y install libvirt-daemon-driver-* libvirt-daemon libvirt-daemon-kvm qemu-kvm qemu-kvm-tools
RUN localedef -i en_US -c -f UTF-8 en_US.UTF-8
RUN rm -rf /etc/sysconfig/network-scripts/ifcfg-*
RUN yum install -y tuned kexec-tools iptables-services; yum clean all
RUN mkdir -p /etc/iscsi;
# ovirt-container-node

RUN yum install -y http://resources.ovirt.org/pub/yum-repo/ovirt-release-master.rpm
# RUN yum install -y http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm
RUN yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm
RUN yum install -y iproute grub2-tools openssh-server vdsm vdsm-cli vdsm-hook-faqemu; yum clean all;

ADD scripts/* /root/
# conf for host-deploy to avoid the upgrade check
RUN mkdir /etc/ovirt-host-deploy.conf.d
# NOTE: commented out - trying to use regular deploy flow
ADD confs/50-offline-packager.conf /etc/ovirt-host-deploy.conf.d/
ADD confs/vdsm.conf /etc/vdsm/vdsm.conf
ADD confs/sanlock.conf /etc/sanlock/sanlock.conf

# for some reason this file is missing when running vdsm-tool configure
RUN touch /etc/libvirt/qemu-sanlock.conf

# this is a service that will run deploy.sh after vdsm is up
RUN mv /root/vdsm-deploy.service /usr/lib/systemd/system/
RUN systemctl enable vdsm-deploy.service

# removing multipath dependency
RUN sed -i 's/multipathd.service //g' /usr/lib/systemd/system/vdsmd.service

# we need to enable vdsm and supervdsm to start. not part of configure yet, but should
RUN systemctl enable vdsmd.service supervdsmd.service sshd.service

# running configure - must be done before running init
RUN vdsm-tool configure --force

EXPOSE 54321

CMD ["/usr/sbin/init"]
