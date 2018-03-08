nodes = [
  { :hostname => 'kubernetes-master',  :ip => '172.16.66.2', :ram => 2048 },
  { :hostname => 'kubernetes-node1',  :ip => '172.16.66.3', :ram => 1048 },
  { :hostname => 'kubernetes-node2',  :ip => '172.16.66.4', :ram => 1048 }
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    #config.vm.auto_update = false

    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = "minimal/xenial64";
      nodeconfig.vm.hostname = node[:hostname] + ".box"
      nodeconfig.vm.network :private_network, ip: node[:ip]
      nodeconfig.vm.boot_timeout = 600

      memory = node[:ram] ? node[:ram] : 256;
      nodeconfig.vm.provider :virtualbox do |vb|
        vb.customize [
          "modifyvm", :id,
          "--memory", memory.to_s,
          "--cpus", "2"
        ]
      end

      # Install python since minimal xenial64 (stripped down ubuntu 16.04) would not have it and ansible would need it
      config.vm.provision :shell, :inline => <<-SCRIPT
        apt-get update
        apt-get -y install python
        SCRIPT

    end
  end
end
