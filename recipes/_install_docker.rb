#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_docker'] == true
  # package 'linux-image-extra-virtual'
  # package 'linux-image-extra-3.13.0-61-generic'

  package 'apt-transport-https'

  apt_repository 'docker' do
    uri 'https://apt.dockerproject.org/repo'
    distribution 'ubuntu-trusty'
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key '58118E89F3A912897C070ADBF76221572C52609D'
    action :add
  end

  package 'docker-engine' do
    version '1.11.2-0~trusty'
  end

  service 'docker' do
    provider Chef::Provider::Service::Upstart
    action [:enable, :start]
  end

  cookbook_file 'default-docker' do
    path '/etc/default/docker'
    mode '0600'
    notifies :restart, 'service[docker]', :immediately
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
      fi
      sleep 1
      I=$(expr $I + 1)
    done
    if [ $DOCKER_UP -eq 0];then
      exit 1
    fi
    EOH
  end

  # docker pull pingworks/docker-ws-baseimg
  bash 'pull docker ws baseimg' do
    user node['workshopbox']['adminuser']['username']
    group 'adm'
    environment ({ 'HOME' => node['workshopbox']['adminuser']['home'], 'USER' => node['workshopbox']['adminuser']['username'] })
    code <<-EOC
      docker pull #{node['workshopbox']['kitchen-docker']['baseimg']}
    EOC
  end
end
