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

  # bash 'setting up git for user ' + username do
  #   user username
  #   environment ({ 'HOME' => "/home/#{username}", 'USER' => username })
  #   code <<-EOC
  #     git config --global user.email "$(cat #{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/email)"
  #     git config --global user.name "$(cat #{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/firstname) $(cat #{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/lastname)"
  #   EOC
  # end

  cookbook_file "/home/#{username}/.ssh/config" do
    owner username
    group username
    mode 0600
  end

  firstname = File.read("#{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/firstname").chomp
  lastname = File.read("#{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/lastname").chomp
  email = File.read("#{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/email").chomp

  template "/home/#{username}/.gitconfig" do
    owner username
    group username
    mode 0644
    variables(
      fullname: "#{firstname} #{lastname}",
      email: email
    )
  end
end
