#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_atom
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_gnome_desktop'] == true

  # Make a prototyporal installation for user testuser and clone it into all the other useraccounts
  directory '/home/testuser/.atom' do
    owner 'testuser'
    group 'testuser'
    mode 00755
    recursive true
    action :create
  end

  directory '/home/testuser/.atom/storage' do
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

  if node['workshopbox']['tweak']['install_atom_pkgs'] == true
    node['workshopbox']['atom_pkgs'].each do |apkg|
      bash 'installing atom package ' + apkg do
        user 'testuser'
        group 'testuser'
        cwd '/home/testuser'
        environment ({ 'HOME' => '/home/testuser', 'USER' => 'testuser' })
        code <<-EOH
          apm install #{apkg}
          EOH
      end
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
    next if username == '.' || username == '..'

    if username != 'testuser'
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

    template "/home/#{username}/.atom/storage/application.json" do
      source 'application.json.erb'
      owner username
      group username
      mode 00644
      variables(
        username: username
      )
    end
  end
end
