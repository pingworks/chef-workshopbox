#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_docker'] == true
  include_recipe 'apt'
  ['apt-transport-https', 'ca-certificates', "linux-image-extra-#{node['kernel']['release']}", 'linux-image-extra-virtual'].each do |pkg|
    package pkg
  end

  apt_repository 'docker' do
    uri 'https://apt.dockerproject.org/repo'
    distribution 'ubuntu-xenial'
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key '58118E89F3A912897C070ADBF76221572C52609D'
    action :add
  end

  package 'docker-engine' do
    version '1.11.2-0~xenial'
  end

  bash 'set docker-engine package on hold' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
    apt-mark hold docker-engine
    EOH
  end

  service 'docker' do
    provider Chef::Provider::Service::Systemd
    action [:enable, :start]
  end

  package 'bash-completion'

  cookbook_file '/etc/bash_completion.d/docker' do
    owner 'root'
    group 'root'
    mode 00644
  end

  bash 'make sure docker is up and running' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
    I=0
    DOCKER_UP=0
    while [ $I -lt 30 -a $DOCKER_UP -eq 0 ];do
      if docker version >/dev/null 2>&1;then
        DOCKER_UP=1
        sleep 1
      fi
      sleep 1
      I=$(expr $I + 1)
    done
    if [ $DOCKER_UP -eq 0];then
      exit 1
    fi
    EOH
  end

  group 'docker' do
    action :modify
    members node['workshopbox']['adminuser']['username']
    append true
  end
end
