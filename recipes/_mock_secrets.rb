#
# Cookbook Name:: ws-workshopbox
# Recipe:: _mock_secrets
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

directory "#{node['ws-workshopbox']['secret']['repo']}/user/#{node['ws-workshopbox']['user']['username']}" do
  owner node['ws-workshopbox']['secret']['user']
  group node['ws-workshopbox']['secret']['user']
  mode 00700
  recursive true
end

bash "Mocking secrets for user #{node['ws-workshopbox']['user']['username']}" do
  code <<-EOC
    echo #{node['ws-workshopbox']['user']['username']} > #{node['ws-workshopbox']['secret']['repo']}/user/#{node['ws-workshopbox']['user']['username']}/password
    cp /home/vagrant/.ssh/id_rsa #{node['ws-workshopbox']['secret']['repo']}/user/#{node['ws-workshopbox']['user']['username']}/id_rsa
    cp /home/vagrant/.ssh/id_rsa.pub #{node['ws-workshopbox']['secret']['repo']}/user/#{node['ws-workshopbox']['user']['username']}/id_rsa.pub
    chown -R #{node['ws-workshopbox']['secret']['user']}.#{node['ws-workshopbox']['secret']['user']} #{node['ws-workshopbox']['secret']['repo']}/user/#{node['ws-workshopbox']['user']['username']}
    chmod 0600 #{node['ws-workshopbox']['secret']['repo']}/user/#{node['ws-workshopbox']['user']['username']}/password
    chmod 0600 #{node['ws-workshopbox']['secret']['repo']}/user/#{node['ws-workshopbox']['user']['username']}/id_rsa
    chmod 0644 #{node['ws-workshopbox']['secret']['repo']}/user/#{node['ws-workshopbox']['user']['username']}/id_rsa.pub
  EOC
end
