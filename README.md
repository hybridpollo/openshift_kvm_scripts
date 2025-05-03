## About this repository

This repository consists of a number of basic scripts and instructions to deploy
a user-provisioned Red Hat OpenShift Container Platform on baremetal. 

The "baremetal" term used here refers to KVM/libvirt virtual machines deployed on top of a
RHEL host. The objective is to deploy an OpenShift reference architecture
consisting of 3 x masters, 3 x infra, and 3 x worker nodes with the least amount
of hardware as possible. 


## Assumptions
- You know your way around the Linux CLI.
- You have a RHEL or Linux host with KVM/Libvirt capabilities.
- This RHEL or Linux host has enough CPU, Memory, Disk capacity to accomodate
  these vms. See example hardware that I used below
- You undertand that this is not to be used as a production deployment and its
  simply an easy way to have a production grade reference architecture in a single node.
- You require access to a dns domain and can add / modify dns records necessary.

## Example hardware used on my lab
In my case, I have an HP DL360 G9 with the following specs:
- CPU:     2x Intel(R) Xeon(R) CPU E5-2697A v4 @ 2.60GHz
- Memory:  256GB
- Disk:    1T RAID5(OS) + 3T RAID 1+0(virtual machine storage)
- NIC:     1 x 10G single nic (its a lab after all)
Minimum resource requirements are documented in this link:  [Minimum resource
requirements for cluster
installation](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/installing_on_bare_metal/user-provisioned-infrastructure#installation-minimum-resource-requirements_installing-bare-metal)

## Scripts and files used in this lab
Source images used to build the vm disks:  
- rhel-9.5-x86_64-kvm.qcow2: This rhel image used to build the haproxy
  loadbalancer vm. You can use any linux distribution that can run haproxy.
- rhcos-4.18.1-x86_64-qemu.x86_64.qcow2: This is the coreos image use to launch
  the OpenShift vms. 

Scripts used to launch the vms:
- 00_create_ocp_vm_disks.sh: Creates the virtual machine image disk using a
source qcow2 image. 
- 01_deploy_ocp_lb.sh:Ddeploys the rhel virtual machine to host the haproxy
load balancer. 
- 02_deploy_ocp_bootstrap.sh: Deploys the Openshift bootstrap virtual machine
- 03_deploy_ocp_master_1.sh:  Deploys an Openshift master node.
- 04_deploy_ocp_master_2.sh:  Deploys an Openshift master node.
- 05_deploy_ocp_master_3.sh:  Deploys and OpenShift master node.
- 06_deploy_ocp_worker_1.sh:  Deploys and OpenShift worker node.
- 07_deploy_ocp_worker_2.sh:  Deploys and OpenShift worker node.
- 08_deploy_ocp_worker_3.sh:  Deploys and OpenShift worker node.
- 09_deploy_ocp_infra_1.sh:   Deploys and OpenShift infra node.
- 10_deploy_ocp_infra_2.sh:   Deploys and OpenShift infra node.
- 11_deploy_ocp_infra_3.sh:   Deploys and OpenShift infra node.
- 99_delete_ocp_vm_disks.sh:  Deletes all vm disks. Note that this only works if
the vms are stopped/shutdown and the script will fail if the vms are running.


## Pre-requisites
Before you start launching vms, you must follow the Red Hat OpenShift Container
Platform 

Red Hat OpenShift Container platform documentation is massive. As we are
deploying a user-provisioned-infrastructure cluster on baremetal.  We can use
this reference documentation link as the base: 
[Installing Red Hat OpenShift Container Platform on
Baremetal[(https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/installing_on_bare_metal/user-provisioned-infrastructure#installing-bare-metal)

- point 1
- point 2
- point 3

