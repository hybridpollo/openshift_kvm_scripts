#!/usr/bin/env bash

# vars
DEST_PATH="/var/lib/libvirt/images"
RESPONSE=""

# Prompt for answer
read -p "$(date +%c): This procedure is destructive! Do you want to delete the virtual machine disks? (yes/no) " RESPONSE
if [[ $RESPONSE =~ ^[Yy][Ee][Ss] ]] || [[ $RESPONSE =~ ^[Yy] ]]; then 
  read -p "$(date +%c): Proceeding to delete the virtual machine disks. Press enter to continue..."
  # delete root disks for image
  for i in lb bootstrap master1 master2 master3 infra1 infra2 infra3 worker1 worker2 worker3; do
    printf "%s\n" "Deleting base kvm virtual machine disk for ${i}..."
    rm -f ${DEST_PATH}/ocp4-${i}.qcow2
    printf "%s\n" "Done deleting disk for ${i}..."
  done
  printf "%s\n" "$(date +%c): OpenShift virtual machine disks have been deleted at your request...."
else
  printf "%s\n" "$(date +%c): Exiting the script. No actions to perform based on user input."
fi 


