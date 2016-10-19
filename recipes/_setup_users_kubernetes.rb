#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_docker
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_docker'] == true
  Dir.foreach(node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
    next if username == '.' || username == '..'
    directory "/home/#{username}/.kube" do
      owner username
      group username
      mode 00755
      action :create
    end

    bash 'copy admin access certs' do
      user 'root'
      cwd '/tmp'
      code <<-EOH
      cp #{node['workshopbox']['secret_service']['client']['repo']}/user/testuser/kubernetes/.kube/config /home/#{username}/.kube/config
      chown #{username}.#{username} /home/#{username}/.kube/config
      chmod 600 /home/#{username}/.kube/config
      EOH
    end
  end
end
