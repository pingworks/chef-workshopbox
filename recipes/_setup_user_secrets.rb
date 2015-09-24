#
# Cookbook Name:: wsbox_base
# Recipe:: _setup_user_secrets
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

directory "/root/secret/user/#{node['wsbox_base']['user']['username']}" do
  owner 'root'
  group 'root'
  mode 00700
  recursive true
end

bash 'get user password' do
  code <<-EOC
     scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i #{node['wsbox_base']['secret']['user_key']} #{node['wsbox_base']['user']['secret']['password']} /root/secret/user/#{node['wsbox_base']['user']['username']}/password
     chmod 0600 /root/secret/user/#{node['wsbox_base']['user']['username']}/password
  EOC
end

bash 'get user private key' do
  code <<-EOC
     scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i #{node['wsbox_base']['secret']['user_key']} #{node['wsbox_base']['user']['secret']['id_rsa']} /root/secret/user/#{node['wsbox_base']['user']['username']}/id_rsa
     chmod 0600 /root/secret/user/#{node['wsbox_base']['user']['username']}/id_rsa
  EOC
end

bash 'get user public key' do
  code <<-EOC
     scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i #{node['wsbox_base']['secret']['user_key']} #{node['wsbox_base']['user']['secret']['password']} /root/secret/user/#{node['wsbox_base']['user']['username']}/id_rsa.pub
     chmod 0644 /root/secret/user/#{node['wsbox_base']['user']['username']}/id_rsa.pub
  EOC
end
