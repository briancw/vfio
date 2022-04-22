#!/bin/sh

# My own attempt at cpu isolation following the arch wiki
# https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Isolating_pinned_CPUs
# and a cset script from the makers of the Hooks utility
# https://github.com/PassthroughPOST/VFIO-Tools/blob/master/libvirt_hooks/hooks/cset.sh

# Isolate CPU cores 0 and 1 to the host on startup
systemctl set-property --runtime -- user.slice AllowedCPUs=0,1
systemctl set-property --runtime -- system.slice AllowedCPUs=0,1
systemctl set-property --runtime -- init.scope AllowedCPUs=0,1

# Something Something more cpu isolation
# From cset script. I don't really understand what this is doing
echo 0 > /sys/bus/workqueue/devices/writeback/numa

# From a redhat pdf on VM perf
# http://progplus.com/unigroup/Unigroup_20171019_RedHat_Performance_Brief_Low_Latency_Tuning_RHEL7.v2.draft.pdf
# 3 is a bitmask for core 0 and 1, which is perfect for my 9700k setup
echo 3 > /sys/bus/workqueue/devices/writeback/cpumask

# Potentially do this as well to move all tasks to CPU0
# echo 1 > /sys/devices/virtual/workqueue/cpumask
