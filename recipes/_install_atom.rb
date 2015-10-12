#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
include_recipe 'apt'

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

cookbook_file "/var/tmp/atom-config_0.1.0.tar.gz" do
  owner 'root'
  group 'root'
  mode 00644
end

Dir.foreach(node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
  next if username == '.' or username == '..'
  bash 'untar atom config' do
    user username
    group username
    environment ({'HOME' => "/home/#{username}", 'USER' => username })
    code <<-EOC
      cd /home/#{username}
      tar xvfz /var/tmp/atom-config_0.1.0.tar.gz
      chown -R #{username}.#{username} /home/#{username}/.atom
    EOC
  end
end
