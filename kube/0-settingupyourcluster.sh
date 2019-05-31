#These instructions are tested with Ubuntu 18.04 Bionic Beaver LTS
#2 CPU and 6 GB ram and 30GB disk

#Docker Installation and Overview
#Add GPG key:

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Add Docker repository:

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#Update packages:

sudo apt-get update

#Install Docker:

sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu

#Disable swap, swapoff then edit your fstab removing any entry for swap partitions
sudo swapoff -a
sudo vi /etc/fstab

#Installing Kubeadm, Kubelet, and Kubectl
#Add the GPG key:
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

#Add the Kubernetes repository:
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
#Resynchronize the package index:
sudo apt-get update

#Install the required packages:
sudo apt-get install -y kubelet=1.12.7-00 kubeadm=1.12.7-00 kubectl=1.12.7-00

#Prevent packages from being automatically updated:
sudo apt-mark hold kubelet kubeadm kubectl

#Bootstrap the kubernetes cluster
#Installation Steps:
#Initialize the Cluster on the Master:
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

#Set up kubeconfig for a Local User on the Master
mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

#Join Nodes to the Cluster
sudo kubeadm join $controller_private_ip:6443 --token $token --discovery-token-ca-cert-hash $hash

sudo kubeadm join 192.168.1.107:6443 --token ddk8o4.ssb8uibxs6wclg17 --discovery-token-ca-cert-hash sha256:135d902d199966223404c0adbcabb546fcd8bab39c93e89473d552b8020be5f4
#Configure Cluster Network with Flannel
#Install the Flannel Network Addon

#(on all nodes) Add net.bridge.bridge-nf-call-iptables=1 to sysctl.conf.
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf

#(on all nodes) Apply the change made to sysctl.conf
sudo sysctl -p

#(on Master) Use kubectl to install Flannel using YAML template.
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml