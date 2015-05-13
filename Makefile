# Building the containers makefile

repo-install?=repos/repo-install.sh

container/repo-install.sh: $(repo-install) Makefile
	cp -f $< $@

centos7: container/repo-install.sh
	docker build -f $@/Dockerfile -t $@-vdsmi:latest .

all: centos7

clean :
	rm -rf container/repo-install.sh

.PHONY: all centos7