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
  export DEBIAN_FRONTEND=noninteractive && apt-get -o Dpkg::Options::="--force-confnew" -y --force-yes upgrade
  EOH
end

node['workshopbox']['base_pkgs'].each do |pkg|
  package pkg
end
