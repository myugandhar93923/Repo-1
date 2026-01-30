#!/bin/bash

# install containerd
sudo apt update
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
containerd config default \
| sed 's/SystemdCgroup = false/SystemdCgroup = true/' \
| sed 's|sandbox_image = ".*"|sandbox_image = "registry.k8s.io/pause:3.10"|' \
| sudo tee /etc/containerd/config.toml > /dev/null
sudo systemctl restart containerd
sudo swapoff -a

# enable IP forwarding
sudo sysctl -w net.ipv4.ip_forward=1
sudo sed -i '/^#net\.ipv4\.ip_forward=1/s/^#//' /etc/sysctl.conf
sudo sysctl -p

# install kubernetes components
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -p -m 755 /etc/apt/keyrings
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet=1.33.2-1.1 kubeadm=1.33.2-1.1 kubectl=1.33.2-1.1
sudo apt-mark hold kubelet kubeadm kubectl

# next, we need to initialize the kubernetes cluster
# go to the file `initializing-kubernetes.sh`