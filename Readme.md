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

#Engine patching command
su postgres
psql engine
INSERT INTO vdc_options (option_value , option_name) VALUES( E'atomic installcentos7-vdsmi:latest > /dev/null 2>&1 ;systemctl start vdsmc.service;nsenter  --mount --uts --net --pid --ipc --target $(docker inspect --format {{.State.Pid}} $(docker ps | grep vdsmc | awk \'{print $1}\')) /setup/deploy.sh;','BootstrapCommand');
