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
  bash 'untar firefox config' do
    user username
    group username
    environment ({'HOME' => "/home/#{username}", 'USER' => username })
    code <<-EOC
      cd /home/#{username}
      tar xvfz /var/tmp/firefox-config_0.1.0.tar.gz
      chown -R #{username}.#{username} /home/#{username}/.mozilla
      sed -i 's;__USERNAME__;#{username};g' /home/#{username}/.mozilla/firefox/2wd0j2ke.default/prefs.js
    EOC
  end
end
