# ovirt-container-node

[![Build Status](https://travis-ci.org/ovirt/ovirt-container-node.svg?branch=master)](https://travis-ci.org/ovirt/ovirt-container-node)

Dockerized version of ovirt-node, the hypervisor part of oVirt

## Build
Official build of the Dockerfile image is uploaded in https://hub.docker.com/r/ovirtorg/vdsm-kube/

## Run ovirt-node
The instance can be run using docker-compose, docker or kubevirt env [1].
However, the contribution for ovirt-node docker effort is mainly focus on
integrating the instance to kubevirt env. Quickly follow [2] to setup kubevirt
cluster and then follow the following:

Using Kubevirt env [1]:

```
${KUBEVIRT_PATH}/cluster/kubectl.sh create -f ${OVIRT_CONTAINER_NODE_PATH}/manifests/vdsm-kube.yaml
```

This command initiates kuberenetes dasemonset in the kubevirt environment. Means that on
each kubevirt node we will start a container with all ovirt hypervisor requirements.

If the engine is registered in the cluster and reachable via "ovirt-engine" dns name,
the hypervisor instance will register automatically to this ovirt-engine as wait for approval.

 [1] https://github.com/kubevirt/kubevirt/blob/master/README.md
 [2] https://github.com/kubevirt/kubevirt/blob/master/docs/getting-started.md

## NOTES
This instance is running with the following hardcoded changes:
 - sanlock watchdog disabled - modifying sanlock.conf for that
 - multipathd requirement is removed from vdsmd.service
 - vdsm.conf is configured to run nested virtualization
 - host-delpoy is configured not to reinstall packages in the container
 - vdsm-deploy is an additional service that runs after vdsmd is running and set requirements
 - the network interface in the container is renamed
 - root password is ovirt-node
 - using ovirt master repos
