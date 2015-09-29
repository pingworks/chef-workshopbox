#
# Cookbook Name:: ws-workshopbox
# Recipe:: hosts
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
bash 'write hostsfile' do
  code <<-EOF
  echo "127.0.0.1 localhost" > /etc/hosts
  echo "#{node['ipaddress']} #{node['ws-workshopbox']['cname']}.#{node['ws-workshopbox']['domain']} #{node['ws-workshopbox']['cname']}" >> /etc/hosts
  EOF
  #not_if 'test -s /etc/hosts'
end
