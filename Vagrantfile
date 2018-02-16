# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  # maria db
  config.vm.network "forwarded_port", guest: 3306, host: 13306

  # web app
  config.vm.network "forwarded_port", guest: 8080, host: 8888

  # install all the goodies
  config.vm.provision :shell, path: "bootstrap.sh"
end
