#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_docker
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_kubernetes_client'] == true
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
      cp #{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/#{username}-config.zip /home/#{username}/
      cd /home/#{username}
      unzip #{username}-config.zip
      chown -R #{username}.#{username} /home/#{username}/.kube
      chmod 600 /home/#{username}/.kube/config
      rm #{username}-config.zip
      EOH
    end
  end
end
