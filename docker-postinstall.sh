#! /bin/bash

echo "add docker group"
sudo groupadd docker
echo "add $USER to docker group"
sudo usermod -aG docker $USER
echo "should display the group"
groups
echo "now should be working without ps, if not, needs reboot"
docker ps



