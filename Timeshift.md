# Timeshit usb flash+basic installation

## Get timeshift

```bash
sudo apt install timeshift
```

## USB flash commands

```bash
lsblk -f
lsblk

sudo parted /dev/sdb --script mklabel gpt

sudo parted /dev/sdb --script mkpart primary ext4 0% 100%

sudo mkfs.ext4 -L USB /dev/sdb1
```

И дальше по шагам в timeshift