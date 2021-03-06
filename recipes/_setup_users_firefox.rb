#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_cheftooling
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_gnome_desktop'] == true

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

    template "/home/#{username}/.mozilla/firefox/workshop/user.js" do
      source 'firefox-user.js.erb'
      owner username
      group username
      mode 00644
      variables(
        username: username
      )
    end
  end
end
