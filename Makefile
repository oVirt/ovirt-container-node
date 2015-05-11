# Building the containers makefile

centos7:
	docker build -f $@/Dockerfile -t $@-vdsmi:latest .

all: centos7

.PHONY: all centos7