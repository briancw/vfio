VM disk images/snapshots are stored in /var/lib/libvirt/images/

### Manually list VM snapshots
qemu-img snapshot -l your_image.qcow2

### Manually roll back snapshot
qemu-img snashot -a SNAPSHOT_TAG your_image.qcow2
