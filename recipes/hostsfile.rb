#
# Cookbook Name:: wsbox_base
# Recipe:: hosts
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
bash 'write hostsfile' do
  code <<-EOF
  echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
  echo "$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/' ) #{node['wsbox_base']['cname']}.#{node['wsbox_base']['domain']} #{node['wsbox_base']['cname']}" >> /etc/hosts
  EOF
  #not_if 'test -s /etc/hosts'
end
