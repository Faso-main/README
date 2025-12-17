#!/bin/bash
echo "=== BLUETOOTH DIAGNOSTICS ==="
echo ""
echo "1. System Bluetooth Service:"
systemctl status bluetooth --no-pager | grep -E "(Active|Loaded)"
echo ""
echo "2. USB Devices:"
lsusb
echo ""
echo "3. PCI Devices:"
lspci
echo ""
echo "4. Bluetooth Packages:"
dpkg -l | grep -E "(bluez|bluetooth)"
echo ""
echo "5. Kernel Modules:"
lsmod | grep -i bluetooth
echo ""
echo "6. RFKill Status:"
sudo rfkill list
echo ""
echo "7. Adapter Info:"
sudo hcitool dev 2>/dev/null || echo "No hcitool or no adapter"
