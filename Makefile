# Building the containers makefile

# the repo to store the container , currently some local repo I use.
# TBD : to change to real one once acked
docker-repo?="$(shell echo $$USER)/"
repo-install?=repos/repo-install.sh
changes = $(shell git status --porcelain)

container/repo-install.sh: $(repo-install) Makefile
	cp -f $< $@

version-update: container/version-id.txt

container/version-id.txt: Makefile
	@git log -1 > $@

push-prerequisites: version-update
	@if [ ! -z "$(changes)" ]; then echo Working directory is dirty >&2 ; exit 1;fi

centos7: container/repo-install.sh
	docker build -f $@/Dockerfile -t vdsmc:latest .

push-centos7: centos7 push-prerequisites
	docker tag -f vdsmc:latest $(docker-repo)vdsmc:latest
	docker push $(docker-repo)vdsmc:latest

all: centos7

clean :
	rm -rf container/repo-install.sh
	rm -rf container/version-id.txt

.PHONY: all centos7 push-centos7 push-prerequisites version-update