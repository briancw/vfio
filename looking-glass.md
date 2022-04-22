# Looking Glass

### Add shared memory
<shmem name="looking-glass">
  <model type="ivshmem-plain"/>
  <size unit="M">128</size>
  <address type="pci" domain="0x0000" bus="0x00" slot="0x0c" function="0x0"/>
</shmem>

### Disable memballoon
<memballoon model="none"/>

## Inside VM

Shared Memory Driver
  https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/upstream-virtio/
  device manager > PCI Standard Ram Controller > update driver > browse to downloaded file above

### Improve looking glass input with Spice guest tools
https://www.spice-space.org/download.html#windows-binaries
