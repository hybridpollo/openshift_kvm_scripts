#!/usr/bin/env bash 
#
# This script prepares and launches the openshift
# bootstrap vm
# This vm has a static dhcp assignment on an external dhcp server
# provided by a router using the defined mac address in EXT_BRIDGE_MAC variable
# for static ip assignment

IGNITION_CONFIG="/lv_data/kvm_ocp/ocp_upi_installation_directory/bootstrap.ign"
IMAGE="/var/lib/libvirt/images/ocp4-bootstrap.qcow2"
VM_NAME="bootstrap.arl-ocp4.lab.acanorex.io"
VCPUS="8"
RAM_MB="16384"
DISK_GB="100"
EXT_BRIDGE_NAME="br-lab_ext"
EXT_BRIDGE_MAC="52:54:00:ac:15:cb"
IGNITION_DEVICE_ARG=(--qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${IGNITION_CONFIG}")

# Setup the correct SELinux label to allow access to the config
chcon --verbose --type virt_content_t ${IGNITION_CONFIG}

virt-install --connect="qemu:///system" --name="${VM_NAME}" --vcpus="${VCPUS}" --memory="${RAM_MB}" \
        --os-variant=rhel9.4 --import --graphics=none \
        --network bridge=${EXT_BRIDGE_NAME},mac=${EXT_BRIDGE_MAC} "${IGNITION_DEVICE_ARG[@]}" \
        --disk "${IMAGE}" \
        --noautoconsole \
        --noreboot \
        --import

