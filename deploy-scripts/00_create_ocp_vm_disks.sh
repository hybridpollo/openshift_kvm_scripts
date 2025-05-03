#!/usr/bin/env bash
#
# Used to create the base disk for the virtual machine images

# vars
SOURCE_PATH="/var/lib/libvirt/base_images"
DEST_PATH="/var/lib/libvirt/images"
VM_ROOT_PART="/dev/sda4"

# create base root disks for image
for i in lb bootstrap master1 master2 master3 worker1 worker2 worker3 infra1 infra2 infra3 ; do
  printf "%s\n" "Creating the base kvm virtual machine disk for ${i}..."
  if [[ ${i} =~ "lb" ]] || [[ ${i} =~ "bootstrap" ]]; then
    qemu-img create -q -f qcow2 ${DEST_PATH}/ocp4-${i}.qcow2 50G
    printf "%s\n" "Done with ${i}..."
  elif [[ ${i} =~ "bootstrap" ]]; then
    qemu-img create -q -f qcow2 ${DEST_PATH}/ocp4-${i}.qcow2 100G
    printf "%s\n" "Done with ${i}..."
  elif [[ ${i} =~ "master" ]]; then
    qemu-img create -q -f qcow2 ${DEST_PATH}/ocp4-${i}.qcow2 300G
    printf "%s\n" "Done with ${i}..."
  else 
    qemu-img create -q -f qcow2 ${DEST_PATH}/ocp4-${i}.qcow2 200G
    printf "%s\n" "Done with ${i}..."
  fi 
done

# expand the disks to desired size
# root disk partitions on qcow images
# rhel 9, centos 9, rhcos 4.1x the root partition is sda4
#   
for i in lb bootstrap master1 master2 master3 worker1 worker2 worker3 infra1 infra2 infra3 ; do
  if [[ ${i} =~ "lb" ]]; then
    SOURCE_OS_IMG="rhel-9.5-x86_64-kvm.qcow2"
    printf "%s\n" "Expanding the kvm virtual machine disks using the image file ${SOURCE_OS_IMG} for vm: ${i}..."
    virt-resize -q --expand ${VM_ROOT_PART} ${SOURCE_PATH}/${SOURCE_OS_IMG} ${DEST_PATH}/ocp4-${i}.qcow2
    printf "%s\n" "Done expanding the vm disks for ${i}..."
  else
    SOURCE_OS_IMG="rhcos-4.18.1-x86_64-qemu.x86_64.qcow2"
    printf "%s\n" "Expanding the kvm virtual machine disks using the image file ${SOURCE_OS_IMG} for vm: ${i}..."
    virt-resize -q --expand ${VM_ROOT_PART} ${SOURCE_PATH}/${SOURCE_OS_IMG} ${DEST_PATH}/ocp4-${i}.qcow2
    printf "%s\n" "Done expanding the vm disks for ${i}..."
  fi 
done

