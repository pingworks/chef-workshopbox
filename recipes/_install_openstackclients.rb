#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
apt_repository 'cloudarchive-kilo' do
  uri 'http://ubuntu-cloud.archive.canonical.com/ubuntu'
  distribution 'trusty-updates/kilo'
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'EC4926EA'
  action :add
end

node['workshopbox']['openstack_pkgs'].each do |pkg|
  package pkg
end
