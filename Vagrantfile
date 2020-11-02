Vagrant.configure("2") do |config|

  # ansible provision
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/flask_app_playbook.yml"
    ansible.extra_vars = { ansible_python_interpreter:"/usr/bin/python3" }
    ansible.host_key_checking = false
    ansible.verbose = "vv"
  end

  config.vm.define "flaskapp" do |server|
    server.vm.box = "ubuntu/bionic64"
    server.vm.hostname = "flaskapp"
    server.vm.box_check_update = false
    server.vm.network "private_network", ip: "192.168.33.10"
    server.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end
  end

end