#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_cheftooling
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

# Make a prototyporal installation for user testuser and clone it into all the other useraccounts
directory '/home/testuser/.atom' do
  owner 'testuser'
  group 'testuser'
  mode 00755
  recursive true
  action :create
end

cookbook_file '/home/testuser/.atom/.apmrc' do
  owner 'testuser'
  group 'testuser'
  mode 00644
end

node['workshopbox']['atom_pkgs'].each do |apkg|
  bash 'installing atom package ' + apkg do
    user 'testuser'
    group 'testuser'
    cwd '/home/testuser'
    environment ({'HOME' => '/home/testuser', 'USER' => 'testuser' })
    code <<-EOH
      apm install #{apkg}
      EOH
  end
end

cookbook_file '/home/testuser/.atom/config.cson' do
  source 'atom_config.cson'
  owner 'testuser'
  group 'testuser'
  mode 00644
end

cookbook_file '/home/testuser/.atom/keymap.cson' do
  source 'atom_keymap.cson'
  owner 'testuser'
  group 'testuser'
  mode 00644
end

cookbook_file '/home/testuser/.atom/styles.css' do
  source 'atom_styles.css'
  owner 'testuser'
  group 'testuser'
  mode 00644
end

Dir.foreach(node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
  next if username == '.' || username == '..' || username == 'testuser'

  directory "/home/#{username}/.atom" do
    owner username
    group username
    mode 00755
    recursive true
    action :create
  end

  bash 'clone atom config & installed packages' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
    rsync -avx --delete /home/testuser/.atom/ /home/#{username}/.atom/
    chown -R #{username}.#{username} /home/#{username}/.atom
    EOH
  end
end
