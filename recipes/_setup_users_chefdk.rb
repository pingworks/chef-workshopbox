#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_cheftooling
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
bash 'setup chefdk for root' do
  user 'root'
  cwd '/root'
  environment ({'HOME' => '/root', 'USER' => 'root' })
  code <<-EOC
    echo 'eval "$(chef shell-init bash)"' >> /root/.profile
  EOC
  not_if "grep 'chef shell-init bash'  /root/.profile"
end

Dir.foreach(node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
  next if username == '.' || username == '..' || node['workshopbox']['secret_service']['client']['ignore_users'].include?(username)

  bash 'setup chefdk for user ' + username do
    user username
    cwd "/home/#{username}"
    environment ({'HOME' => "/home/#{username}", 'USER' => username})
    code <<-EOC
      echo 'eval "$(chef shell-init bash)"' >> /home/#{username}/.profile
    EOC
    not_if "grep 'chef shell-init bash'  /home/#{username}/.profile"
  end

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
    source 'mofa-config.yml.erb'
    owner username
    group username
    mode 00644
    variables(
      username: username
    )
  end
end
