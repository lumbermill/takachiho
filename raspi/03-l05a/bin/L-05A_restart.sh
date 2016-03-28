#!/bin/bash
if sudo ping -c 2 160.16.118.143;then
  echo "Network connection is OK."
else
	sudo reboot
fi