# Building the containers makefile

# the repo to store the container , currently some local repo I use.
# TBD : to change to real one once acked
virt-branch?=ovirt35-snapshot
docker-repo?="$(shell echo $$USER)/"
repo-install?=repos/repo-$(virt-branch).sh
changes = $(shell git status --porcelain)

repoinstall:
	@cmp -s $(repo-install) repo/repo-install.sh; \
	if [ $$? -ne 0 ] ; then \
		echo "Updating repo file"; \
		mkdir -p repo; \
		cp -f $(repo-install) repo/repo-install.sh ; \
	fi


version-update: container/version-id.txt

container/version-id.txt: Makefile
	@git log -1 > $@

push-prerequisites: version-update
	@if [ ! -z "$(changes)" ]; then echo Working directory is dirty >&2 ; exit 1;fi

container/repo-install.sh : repoinstall

centos7: container/repo-install.sh
	docker build -f $@/Dockerfile -t vdsmc:$(virt-branch) .

push-centos7: centos7 push-prerequisites
	docker tag -f vdsmc:$(virt-branch) $(docker-repo)vdsmc:$(virt-branch)
	docker push $(docker-repo)vdsmc:$(virt-branch)

all: centos7

clean :
	rm -rf repo/repo-install.sh
	rm -rf container/version-id.txt

.PHONY: all centos7 push-centos7 push-prerequisites version-update repoinstall

 # vim: sw=4 et sts=4: