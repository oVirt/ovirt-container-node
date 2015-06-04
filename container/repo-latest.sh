#!/usr/bin/bash

yum-config-manager --add-repo=http://resources.ovirt.org/pub/yum-repo
yum install -y ovirt-release-master --nogpgcheck