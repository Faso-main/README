# Docker Desktop Installation on Ubuntu

## Prerequisites

- Ubuntu 22.04 LTS or newer
- 4 GB RAM minimum
- Virtualization enabled in BIOS

## Installation

### 1. Update System

```bash
sudo apt update && sudo apt -y upgrade
```

### 2. Install Prerequisites

```bash
sudo apt install -y ca-certificates curl
```

### 3. Add Docker Repository Key

```bash
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

### 4. Download Docker Desktop Package

```bash
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb
```

### 5. Install Docker Desktop

```bash
sudo apt install -y ./docker-desktop-amd64.deb
```

### 6. Start Docker Desktop Service

```bash
systemctl --user start docker-desktop
```

### 7. Add User to Docker Group

```bash
sudo usermod -aG docker $USER
```

Log out and log back in for group changes to take effect.

### 8. Launch Docker Desktop

```bash
docker-desktop
```

## Verification

```bash
docker --version
docker run hello-world
docker compose version
```

## Enable Automatic Start (Optional)

```bash
systemctl --user enable docker-desktop
```

## Clean Up

```bash
rm docker-desktop-amd64.deb
```

## Troubleshooting

### Permission Denied

If Docker commands require sudo after adding user to docker group, log out and log back in or restart the system.

### Check Service Status

```bash
systemctl --user status docker-desktop
journalctl --user -u docker-desktop
```

### Fix Broken Dependencies

```bash
sudo apt --fix-broken install
```

## Uninstall

```bash
sudo apt remove docker-desktop
rm -rf ~/.docker/desktop
sudo rm /usr/local/bin/com.docker.cli
```
