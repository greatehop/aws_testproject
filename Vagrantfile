Vagrant.configure("2") do |config|

  # install packages for network configuration
  # just to avoid possible errors:
  # "bash: line 3: /sbin/ifdown: No such file or directory"
  # "bash: line 19: /sbin/ifup: No such file or directory"
  #config.vm.provision "shell", inline: <<-SHELL
  #     apt-get update
  #     apt-get install -y ifupdown
  #SHELL
  # ansible provision

  #config.vm.provision "ansible" do |ansible|
#    ansible.playbook = "ansible/deploy.yml"
#    ansible.host_key_checking = false
#    ansible.verbose = "vv"

  config.vm.define "flaskapp" do |server|
    server.vm.box = "ubuntu/bionic64"
    server.vm.hostname = "flaskapp"
    server.vm.box_check_update = false
    server.vm.network "private_network", ip: "192.168.33.10"
    server.vm.provider "virtualbox" do |vb|
      #vb.gui = true
      vb.memory = "2048"
    end
  end

end