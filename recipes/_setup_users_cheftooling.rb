#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_cheftooling
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

Dir.foreach(node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
  next if username == '.' || username == '..'

  cookbook_file "/home/#{username}/.rspec" do
    owner username
    group username
    mode 00644
  end

  directory "/home/#{username}/.mofa" do
    owner username
    group username
    mode 00755
    recursive true
    action :create
  end

  template "/home/#{username}/.mofa/config.yml" do
    source 'config.yml.user.erb'
    owner username
    group username
    mode 00644
    variables(
      username: username
    )
  end
end
