#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

include_recipe 'apt'

bash 'upgrade box' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  apt-get upgrade --yes
  EOH
end

node['workshopbox']['base_pkgs'].each do |pkg|
  package pkg
end
