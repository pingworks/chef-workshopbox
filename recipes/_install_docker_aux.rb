#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_docker_aux'] == true
  directory '/etc/docker/certs.d/registry:5000/' do
    owner 'root'
    group 'root'
    mode 00755
    recursive true
    action :create
  end

  bash 'copy docker cert' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
    cp #{node['workshopbox']['secret_service']['client']['repo']}/common/registry.crt /etc/docker/certs.d/registry\:5000/ca.crt
    chmod 644  /etc/docker/certs.d/registry\:5000/ca.crt
    EOH
  end

  # docker pull pingworks/docker-ws-baseimg
  bash 'pull docker ws baseimg' do
    user node['workshopbox']['adminuser']['username']
    group 'docker'
    environment ({ 'HOME' => node['workshopbox']['adminuser']['home'], 'USER' => node['workshopbox']['adminuser']['username'] })
    code <<-EOC
      docker pull #{node['workshopbox']['kitchen-docker']['baseimg']}
    EOC
  end

  cookbook_file 'default-docker' do
    path '/etc/default/docker'
    mode '0600'
    notifies :restart, 'service[docker]', :immediately
  end
end
