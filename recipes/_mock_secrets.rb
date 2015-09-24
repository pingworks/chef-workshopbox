#
# Cookbook Name:: wsbox-base
# Recipe:: _mock_secrets
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

directory "#{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}" do
  owner node['wsbox-base']['secret']['user']
  group node['wsbox-base']['secret']['user']
  mode 00700
  recursive true
end

bash "Mocking secrets for user #{node['wsbox-base']['user']['username']}" do
  code <<-EOC
    echo #{node['wsbox-base']['user']['username']} > #{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}/password
    cp /home/vagrant/.ssh/id_rsa #{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}/id_rsa
    cp /home/vagrant/.ssh/id_rsa.pub #{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}/id_rsa.pub
    chown -R #{node['wsbox-base']['secret']['user']}.#{node['wsbox-base']['secret']['user']} #{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}
    chmod 0600 #{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}/password
    chmod 0600 #{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}/id_rsa
    chmod 0644 #{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}/id_rsa.pub
  EOC
end
