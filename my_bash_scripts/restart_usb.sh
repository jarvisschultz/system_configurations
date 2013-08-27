#!/bin/bash

echo -n "0000:00:1a.0" | sudo tee /sys/bus/pci/drivers/ehci_hcd/unbind
echo
echo -n "0000:00:1d.0" | sudo tee /sys/bus/pci/drivers/ehci_hcd/unbind
echo
echo -n "0000:00:1a.0" | sudo tee /sys/bus/pci/drivers/ehci_hcd/bind
echo
echo -n "0000:00:1d.0" | sudo tee /sys/bus/pci/drivers/ehci_hcd/bind
echo
