#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

apt_repository 'atom-ppa' do
  uri 'http://ppa.launchpad.net/webupd8team/atom/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'EEA14886'
end

apt_package 'atom' do
  action :install
end
