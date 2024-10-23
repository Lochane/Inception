# -*- mode: ruby -*-
# vi: set ft=ruby :

LOCAL_USER = ENV['USER']

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "#{LOCAL_USER}"
  config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.memory = 4096
    v.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt update -y
    apt install git vim wget curl -y
    apt install --no-install-recommends ubuntu-desktop -y
    apt install -y --no-install-recommends virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
    curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
    apt install firefox -y
  SHELL

  config.vm.provision "shell", inline: "sudo adduser #{LOCAL_USER} <<EOF
vagrant
vagrant
EOF"

  config.vm.provision "shell", inline: <<-SHELL
    usermod -aG sudo "#{LOCAL_USER}"
    usermod -aG docker "#{LOCAL_USER}"
    echo "127.0.0.1 "#{LOCAL_USER}".42.fr" >> /etc/hosts
    shutdown -r now
  SHELL
end
