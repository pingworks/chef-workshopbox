#
# Cookbook Name:: wsbox-base
# Recipe:: _setup_user
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

bash 'create user' + node['wsbox-base']['user']['username'] do
  code <<-EOC
    useradd #{node['wsbox-base']['user']['username']} --create-home --shell /bin/bash --groups adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare
    echo #{node['wsbox-base']['user']['username']}:$(< /root/secret/user/#{node['wsbox-base']['user']['username']}/password) | chpasswd
  EOC
  not_if do File.exist?(node['wsbox-base']['user']['home']) end
end

bash 'create users ' + node['wsbox-base']['user']['username'] + ' .ssh settings' do
  code <<-EOC
    mkdir ~#{node['wsbox-base']['user']['username']}/.ssh
    cp /root/secret/user/#{node['wsbox-base']['user']['username']}/id_rsa.pub ~#{node['wsbox-base']['user']['username']}/.ssh/authorized_keys
    cp /root/secret/user/#{node['wsbox-base']['user']['username']}/id_rsa.pub ~#{node['wsbox-base']['user']['username']}/.ssh/id_rsa.pub
    cp /root/secret/user/#{node['wsbox-base']['user']['username']}/id_rsa ~#{node['wsbox-base']['user']['username']}/.ssh/id_rsa
    chown -R #{node['wsbox-base']['user']['username']}.#{node['wsbox-base']['user']['username']} ~#{node['wsbox-base']['user']['username']}/.ssh
    chmod -R go-rwsx ~#{node['wsbox-base']['user']['username']}/.ssh
  EOC
  not_if do File.exist?(node['wsbox-base']['user']['home'] + '/.ssh') end
end

%w(.bash_logout .bashrc .dmrc .profile .xinputrc).each do |f|
  cookbook_file node['wsbox-base']['user']['home'] + '/' + f do
    owner node['wsbox-base']['user']['username']
    group node['wsbox-base']['user']['username']
    mode 00644
  end
end

%w(.config .gconf .local).each do |d|
  directory node['wsbox-base']['user']['home'] + '/' + d do
    owner node['wsbox-base']['user']['username']
    group node['wsbox-base']['user']['username']
    mode 00755
  end
end

%w(dconf gnome-session gtk-3.0 update-notifier upstart).each do |d|
  directory node['wsbox-base']['user']['home'] + '/.config/' + d do
    owner node['wsbox-base']['user']['username']
    group node['wsbox-base']['user']['username']
    mode 00755
  end
end

%w(user-dirs.dirs user-dirs.locale).each do |f|
  cookbook_file node['wsbox-base']['user']['home'] + '/.config/' + f do
    owner node['wsbox-base']['user']['username']
    group node['wsbox-base']['user']['username']
    mode 00644
  end
end

cookbook_file node['wsbox-base']['user']['home'] + '/.config/dconf/user' do
  owner node['wsbox-base']['user']['username']
  group node['wsbox-base']['user']['username']
  mode 00644
end

template node['wsbox-base']['user']['home'] + '/.config/gtk-3.0/bookmarks' do
  owner node['wsbox-base']['user']['username']
  group node['wsbox-base']['user']['username']
  mode 00644
end

template '/etc/lightdm/lightdm.conf'

bash 'setup git' do
  user node['wsbox-base']['user']['username']
  group node['wsbox-base']['user']['username']
  environment ({'HOME' => node['wsbox-base']['user']['home'], 'USER' => node['wsbox-base']['user']['username']})
  code <<-EOC
    git config --global user.email "#{node['wsbox-base']['user']['email']}"
    git config --global user.name "#{node['wsbox-base']['user']['fullname']}"
  EOC
end
