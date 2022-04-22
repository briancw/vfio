# How to

## Host Configurations

### Guides used to find this info
https://www.youtube.com/watch?v=3OdlPmPbLII
https://linuxhint.com/install_virtio_drivers_kvm_qemu_windows_vm/
https://github.com/bryansteiner/gpu-passthrough-tutorial

### Add kernel params to grub to prevent linux from attaching VM GPU
Get GPU id with:
  lspci -nnk
sudo nano /etc/default/grub
  intel_iommu=on iommu=pt rd.driver.pre=vfio_pci pci-stub.ids=xx:xx,xx:xx
sudo update-grub

### Configure Dracut (This doesn't seem necessary or improves perf on my setup)
sudo pacman -S dracut
sudo nano /etc/dracut.conf.d/brianvfio.conf
  add_drivers+="vfio vfio_iommu_type1 vfio_pci vfio_virqfd"

### Set CPU to Performance mode
(TODO: configure hooks to enable perf mode when VM starts)
sudo cpupower frequency-set -g performance

### Setup bridge network
https://www.youtube.com/watch?v=DYpaX4BnNlg

### Hooks
#### Install Hooks Helper
https://passthroughpo.st/simple-per-vm-libvirt-hooks-with-the-vfio-tools-hook-helper/

sudo mkdir /etc/libvirt/hooks
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' -O /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu
sudo systemctl restart libvirtd

Currently I'm using the better-hugepages script:
  https://github.com/PassthroughPOST/VFIO-Tools/blob/master/libvirt_hooks/hooks/better_hugepages.sh
And setting the cpu governor to perf
  cpupower frequency-set -g performance

### Create hooks script for specific VM before startup and resource allocation
sudo mkdir -p /etc/libvirt/hooks/qemu.d/win10/prepare/begin/
sudo mkdir -p /etc/libvirt/hooks/qemu.d/win10/release/end/
add hooks from this repo

## VM Configuration

### VM Settings
chipset: Q35
bios: UEFI (not any of the OMVF options)
use virtio for main storage
use virtio in bridged mode for nic (notes on setting up bridge below)
### Download virtio driver and mount to VM as sata cdrom
https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md

### VM CPU Pinning (Add to vm xml)
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
(TODO: Experiement more with these options)


## Inside VM config

### During Install
press a key to boot directly from iso and skip shell
add storage driver > navigate to the virtio driver disk/amd64/win10
remove windows cdrom from VM (leave virtio)

### After Install
Ethernet and PCI Adapter
  device manager > ethernet adapter > update driver > Uses same disk as virtio disk driver
  device manager > PCI Simple Communications Controller > update driver > same disk as before

### Windows 10 convenience and debloat script
iwr -useb https://git.io/JJ8R4 | iex

### Install MSI Interupt
https://github.com/TechtonicSoftware/MSIInturruptEnabler
