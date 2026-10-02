Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"

  config.vm.define "dashboard01" do |dashboard|
    dashboard.vm.hostname = "dashboard01"
    dashboard.vm.network "private_network", ip: "192.168.30.11"
    dashboard.vm.provider "virtualbox" do |vb|
      vb.name = "dashboard01"
      vb.memory = 1024
      vb.cpus = 1
    end
  end

  config.vm.define "counting01" do |counting|
    counting.vm.hostname = "counting01"
    counting.vm.network "private_network", ip: "192.168.30.12"
    counting.vm.provider "virtualbox" do |vb|
      vb.name = "counting01"
      vb.memory = 1024
      vb.cpus = 1
    end
  end
end
