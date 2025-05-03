#!/usr/bin/env bash 
#
# This script prepares and launches a rhel vm
# that will be used as the haproxy load balancer vm
#
# This vm has a static dhcp assignment on an external dhcp server
# provided by a router using the defined mac address in EXT_BRIDGE_MAC variable
# for static ip assignment

# vars
IMAGE="/var/lib/libvirt/images/ocp4-lb.qcow2"
VM_DOMAIN="lab.acanorex.io"
VM_NAME="lb.arl-ocp4"
VM_ROOT_PW="redhat"
VCPUS="2"
RAM_MB="2048"
EXT_BRIDGE_NAME="br-lab_ext"
EXT_BRIDGE_MAC="00:16:3e:1e:e3:fb"


# set the root password on the virtual machine
LIBGUESTFS_BACKEND=direct
printf "%s\n" "Setting the root and user passwords for vm: ${VM_NAME}..."
virt-customize -q -a "${IMAGE}" --hostname "${VM_NAME}.${VM_DOMAIN}" --uninstall cloud-init --root-password "password:${VM_ROOT_PW}" --selinux-relabel --run-command 'useradd ocp-admin ; echo "redhat" | passwd --stdin ocp-admin'
printf "%s\n" "Done setting the root and user passwords for vm: ${VM_NAME}..."

# define it and start it
virt-install --connect="qemu:///system" --name="${VM_NAME}.${VM_DOMAIN}" --vcpus="${VCPUS}" --memory="${RAM_MB}" \
             --os-variant=rhel9.2 --import --graphics=none \
             --network bridge="${EXT_BRIDGE_NAME}",mac="${EXT_BRIDGE_MAC}" \
             --disk "${IMAGE}" \
             --noautoconsole \
             --import

