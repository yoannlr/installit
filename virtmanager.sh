#!/bin/sh

sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager virt-viewer ovmf virtinst
me="$(whoami)"
sudo usermod -aG libvirt "$me"
sudo virsh net-autostart default
echo 'libvirt installed. Log-out and log back in to refresh your groups.'
