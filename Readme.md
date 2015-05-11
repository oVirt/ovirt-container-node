##This is the project for deploying VDSM in a container

#Installing docker and atomic command
1. yum install docker atomic
2. systemctl enable docker
3. systemctl start docker

#Building
* make all - will build all variants
* make centos7 - will build centos7 based container

#Installing build container
* atomic install centos7-vdsmi