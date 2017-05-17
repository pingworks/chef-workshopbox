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

    bash 'copy user access certs' do
      user 'root'
      cwd '/tmp'
      code <<-EOH
      if [ -f #{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/config-#{username}.zip ];then
        cp #{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/config-#{username}.zip /home/#{username}
        cd /home/#{username}
        unzip config-#{username}.zip
        chown -R #{username}.#{username} /home/#{username}/.kube
        chmod 600 /home/#{username}/.kube/config
        rm config-#{username}.zip
      EOH
    end
  end
end
