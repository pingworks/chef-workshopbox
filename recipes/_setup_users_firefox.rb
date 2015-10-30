#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_cheftooling
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
cookbook_file '/var/tmp/firefox-config_0.1.0.tar.gz' do
  owner 'root'
  group 'root'
  mode 00644
end

Dir.foreach(node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
  next if username == '.' || username == '..'
  
  directory "/home/#{username}/.mozilla/firefox/workshop" do
    owner username
    group username
    mode 00755
    recursive true
    action :create
  end

  cookbook_file "/home/#{username}/.mozilla/firefox/profiles.ini" do
    source 'firefox-profiles.ini'
    owner username
    group username
    mode 00644
  end

  template "/home/#{username}/.mozilla/firefox/workshop/users.js" do
    source 'firefox-users.js.erb'
    owner 'root'
    group 'root'
    mode 00744
  end

end
