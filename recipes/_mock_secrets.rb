#
# Cookbook Name:: wsbox_base
# Recipe:: _mock_secrets
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

directory "#{node['wsbox_base']['secret']['repo']}/user/#{node['wsbox_base']['user']['username']}" do
  owner node['wsbox_base']['secret']['user']
  group node['wsbox_base']['secret']['user']
  mode 00700
  recursive true
end

bash "Mocking secrets for user #{node['wsbox_base']['user']['username']}" do
  code <<-EOC
    echo #{node['wsbox_base']['user']['username']} > #{node['wsbox_base']['secret']['repo']}/user/#{node['wsbox_base']['user']['username']}/password
    cp /home/vagrant/.ssh/id_rsa #{node['wsbox_base']['secret']['repo']}/user/#{node['wsbox_base']['user']['username']}/id_rsa
    cp /home/vagrant/.ssh/id_rsa.pub #{node['wsbox_base']['secret']['repo']}/user/#{node['wsbox_base']['user']['username']}/id_rsa.pub
    chown -R #{node['wsbox_base']['secret']['user']}.#{node['wsbox_base']['secret']['user']} #{node['wsbox_base']['secret']['repo']}/user/#{node['wsbox_base']['user']['username']}
    chmod 0600 #{node['wsbox_base']['secret']['repo']}/user/#{node['wsbox_base']['user']['username']}/password
    chmod 0600 #{node['wsbox_base']['secret']['repo']}/user/#{node['wsbox_base']['user']['username']}/id_rsa
    chmod 0644 #{node['wsbox_base']['secret']['repo']}/user/#{node['wsbox_base']['user']['username']}/id_rsa.pub
  EOC
end
