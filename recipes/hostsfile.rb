#
# Cookbook Name:: workshopbox
# Recipe:: hosts
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
bash 'write hostsfile' do
  code <<-EOF
  echo "127.0.0.1 localhost" > /etc/hosts
  echo "#{node['ipaddress']} #{node['workshopbox']['cname']}.#{node['workshopbox']['domain']} #{node['workshopbox']['cname']}" >> /etc/hosts
  EOF
  #not_if 'test -s /etc/hosts'
end

bash 'hostname' do
  code <<-EOC
  echo "#{node['workshopbox']['cname']}" > /etc/hostname
  EOC
end
