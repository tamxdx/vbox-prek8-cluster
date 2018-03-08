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

Read what it outputs. Have fun.	