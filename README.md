# vbox-prek8-cluster
Spools up 3 virtualbox vm's with kubernete packages installed but not initialized

Purpose:

To create a kubernetes sandbox so we can quickly test things and/or change components

Requirements:

VirtualBox, Vagrant, Ansible on Linux or OSX. If you're using windows.. good luck.

https://www.virtualbox.org/wiki/Downloads
https://www.vagrantup.com/downloads.html

Notes for linux:

while you could install whats is currently in the repo, they are out of date. Just download virtualbox and vagrant latest from the sites listed above.

For ansible however.... since I'm on debian, I did something like...

	$ sudo apt-add-repository ppa:ansible/ansible
	$ sudo apt-get update
	$ sudo apt-get install ansible

since we are already messing with ansible..

	$ sudo vi  /etc/ansible/ansible.cfg

and uncomment 

	host_key_checking = False

Notes for OSX:

Download and install virtualbox and vagrant latest from the sites listed above.

While there are alternative ways to install ansible, lets go with the easiest and use homebrew.

	$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

SshPass is disabled by default because we have to childproof things on OSX.

	$ brew create https://sourceforge.net/projects/sshpass/files/sshpass/1.06/sshpass-1.06.tar.gz --force

	$ brew install sshpass

	$ brew install ansible

Homebrew should also install python and pip as dependencies, but will not mess with the version of preinstalled python that currently exists. In my experience, it's better to just leave whatever that exists alone. Pay attention to the output and modify the paths to python accordingly. So do something like...

	$ vi ~/.bashrc

modify to something like this

	export PATH=$PATH:/usr/local/opt/python@2/libexec/bin

And lastly you will may find that the ansible config file is missing..

	$ sudo curl -L https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg -o /etc/ansible/ansible.cfg

Let's take care of the host key checking..

	$ sudo vi  /etc/ansible/ansible.cfg

and uncomment 

	host_key_checking = False

General Instructions:

	$ vagrant up
	$ sh ./ansible.sh


We can get shell into the the virtualbox vm's like this. The default password is vagrant. Ssh into the master.

	$ vagrant ssh kubernetes-master

 or 

	$ ssh vagrant@127.0.0.1 -p 2222

 or 

 	$ ssh vagrant@172.16.66.2 

While on the master, set it up to be the master.

	$ sudo kubeadm init --apiserver-advertise-address 172.16.66.2 --pod-network-cidr 10.244.0.0/16

Read what it outputs. It will tell you what to execute on the worker nodes to joing the cluster. 
It should be something like this (absolutely copy and paste it to save it somewhere):

	$ sudo kubeadm join --token bf9204.0d7ee0c3def3dd82 172.16.66.2:6443 --discovery-token-ca-cert-hash sha256:565f10974e9a70cbc3b2384f35fb3d25c7352c385e8d54e2a188a73aab1a3779

But before you do that on your worker nodes... there's 2 things to do on the master that will make your life easier.
The first is to give kubectl user permissions: 

	$ mkdir -p $HOME/.kube; sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config; sudo chown $(id -u):$(id -g) $HOME/.kube/config

And the second is to EXIT out of ssh - out of the master. In your console of your home directory of your machine... 
Use the password vagrant when prompted:

	$ mkdir ~/.kube; $ scp vagrant@172.16.66.2:~/.kube/config ~/.kube/config

Now go and get the kubectl binary for your operating system. 

https://kubernetes.io/docs/tasks/tools/install-kubectl/

So for example, on OSX....

	$ brew install kubectl

So what does this do? This allows you to exectue kubectl commands not having to be shelled into your kubernetes master VM. 

	$ kubectl get nodes

Should return your nodes of your cluster and their status.

	
