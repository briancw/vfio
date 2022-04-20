# How to

## Host Setup

### Guides used to find this info
https://www.youtube.com/watch?v=3OdlPmPbLII
https://linuxhint.com/install_virtio_drivers_kvm_qemu_windows_vm/
https://github.com/bryansteiner/gpu-passthrough-tutorial

### Add kernel params to grub to prevent linux from attaching VM GPU
Get GPU id with:
  lspci -nnk
sudo nano /etc/default/grub
  intel_iommu=on iommu=pt rd.driver.pre=vfio_pci pci-stub.ids=xx:xx,xx:xx

### Configure Dracut (This doesn't seem necessary or improves perf on my setup)
sudo pacman -S dracut
sudo nano /etc/dracut.conf.d/brianvfio.conf
  add_drivers+="vfio vfio_iommu_type1 vfio_pci vfio_virqfd"

### Set CPU to Performance mode
(TODO: configure hooks to enable perf mode when VM starts)
cpupower frequency-set -g performance

### Windows VM Main Settings
chipset: Q35
bios: uefi
use virtio for main storage
add virtio driver as cdrom

### Download virtio driver and mount to VM as sata cdrom
https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md

### VM CPU Pinning
<vcpu placement="static">6</vcpu>
<iothreads>1</iothreads>
<cputune>
  <vcpupin vcpu="0" cpuset="2"/>
  <vcpupin vcpu="1" cpuset="3"/>
  <vcpupin vcpu="2" cpuset="4"/>
  <vcpupin vcpu="3" cpuset="5"/>
  <vcpupin vcpu="4" cpuset="6"/>
  <vcpupin vcpu="5" cpuset="7"/>
  <emulatorpin cpuset="0-1"/>
  <iothreadpin iothread="1" cpuset="0-1"/>
</cputune>

### Disable memballoon
<memballoon model="none"/>

### Setup bridge network
https://www.youtube.com/watch?v=DYpaX4BnNlg

## From Inside VM

### During Install
fs0:
cd efi/boot
bootx64
add storage driver > navigate to the virtio driver disk/amd64/win10

### After Install
Ethernet Adapter
  device manager > ethernet adapter > update driver > Uses same disk as virtio disk driver

Shared Memory Driver
  https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/upstream-virtio/
  device manager > PCI Standard Ram Controller > update driver > browse to downloaded file above

### Install MSI Interupt
https://github.com/TechtonicSoftware/MSIInturruptEnabler
