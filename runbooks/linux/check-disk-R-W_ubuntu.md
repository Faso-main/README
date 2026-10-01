# Packages + commands

## smartctl (check for errors)

```bash
sudo apt install smartmontools

sda

sudo smartctl -s on /dev/sda

sudo smartctl -a /dev/sda

sudo smartctl -c /dev/sda

sudo smartctl -t short /dev/sda
sudo smartctl -l selftest /dev/sda

sudo smartctl -t long /dev/sd
sudo smartctl -l selftest /dev/sda
```

## fio (read-write speed)

```bash
sudo apt install fio

lsblk (look for mount point) (--directory=/media/user/ExternalDrive)

fio --name=speedtest --directory=/media/user/ExternalDrive --rw=randrw --bs=4k --size=512M --direct=1 --group_reporting
/media/faso/9fd78552-9e30-47c8-b9c9-011564fd0e64

fio --name=speedtest --directory=/media/faso/9fd78552-9e30-47c8-b9c9-011564fd0e64 --rw=randrw --bs=4k --size=512M --direct=1 --group_reporting

Run status group 0 (all jobs):
   READ: bw=6165KiB/s (6313kB/s), 6165KiB/s-6165KiB/s (6313kB/s-6313kB/s), io=257MiB (269MB), run=42633-42633msec
  WRITE: bw=6132KiB/s (6279kB/s), 6132KiB/s-6132KiB/s (6279kB/s-6279kB/s), io=255MiB (268MB), run=42633-42633msec
```
