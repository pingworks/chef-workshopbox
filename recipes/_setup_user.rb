#
# Cookbook Name:: wsbox_base
# Recipe:: _setup_user
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

bash 'create user' + node['wsbox_base']['user']['username'] do
  code <<-EOC
  useradd #{node['wsbox_base']['user']['username']} --create-home --shell /bin/bash --groups adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare
  echo #{node['wsbox_base']['user']['username']}:#{node['wsbox_base']['user']['password']} | chpasswd
  EOC
  not_if do File.exist?(node['wsbox_base']['user']['home']) end
end

%w(.bash_logout .bashrc .dmrc .profile .xinputrc).each do |f|
  cookbook_file node['wsbox_base']['user']['home'] + '/' + f do
    owner node['wsbox_base']['user']['username']
    group node['wsbox_base']['user']['username']
    mode 00644
  end
end

%w(.config .gconf .local).each do |d|
  directory node['wsbox_base']['user']['home'] + '/' + d do
    owner node['wsbox_base']['user']['username']
    group node['wsbox_base']['user']['username']
    mode 00755
  end
end

%w(dconf gnome-session gtk-3.0 update-notifier upstart).each do |d|
  directory node['wsbox_base']['user']['home'] + '/.config/' + d do
    owner node['wsbox_base']['user']['username']
    group node['wsbox_base']['user']['username']
    mode 00755
  end
end

%w(user-dirs.dirs user-dirs.locale).each do |f|
  cookbook_file node['wsbox_base']['user']['home'] + '/.config/' + f do
    owner node['wsbox_base']['user']['username']
    group node['wsbox_base']['user']['username']
    mode 00644
  end
end

cookbook_file node['wsbox_base']['user']['home'] + '/.config/dconf/user' do
  owner node['wsbox_base']['user']['username']
  group node['wsbox_base']['user']['username']
  mode 00644
end

template node['wsbox_base']['user']['home'] + '/.config/gtk-3.0/bookmarks' do
  owner node['wsbox_base']['user']['username']
  group node['wsbox_base']['user']['username']
  mode 00644
end

template '/etc/lightdm/lightdm.conf'
