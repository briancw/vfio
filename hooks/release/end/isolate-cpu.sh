#!/bin/sh

# My own attempt at cpu isolation following the arch wiki
# https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Isolating_pinned_CPUs
# and a cset script from the makers of the Hooks utility
# https://github.com/PassthroughPOST/VFIO-Tools/blob/master/libvirt_hooks/hooks/cset.sh

# Return all CPU cores to host on shutdown
systemctl set-property --runtime -- user.slice AllowedCPUs=0-7
systemctl set-property --runtime -- system.slice AllowedCPUs=0-7
systemctl set-property --runtime -- init.scope AllowedCPUs=0-7

# Return something something back to all cores
# From cset script. I don't really understand what this is doing
echo 1 > /sys/bus/workqueue/devices/writeback/numa

# Return something to all cores. "11" was the default value on my system.
echo 11 > /sys/bus/workqueue/devices/writeback/cpumask

# Potentially also do this if configured on the setup
# echo ff > /sys/devices/virtual/workqueue/cpumask
