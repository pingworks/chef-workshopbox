#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_docker
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_docker'] == true
  Dir.foreach(node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
    next if username == '.' || username == '..'
    group 'docker' do
      action :modify
      members username
      append true
    end
  end
end
