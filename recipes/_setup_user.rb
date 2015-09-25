#
# Cookbook Name:: ws-workshopbox
# Recipe:: _setup_user
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

bash 'create user' + node['ws-workshopbox']['user']['username'] do
  code <<-EOC
    useradd #{node['ws-workshopbox']['user']['username']} --create-home --shell /bin/bash --groups adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare
    echo #{node['ws-workshopbox']['user']['username']}:$(< /root/secret/user/#{node['ws-workshopbox']['user']['username']}/password) | chpasswd
  EOC
  not_if do File.exist?(node['ws-workshopbox']['user']['home']) end
end

bash 'create users ' + node['ws-workshopbox']['user']['username'] + ' .ssh settings' do
  code <<-EOC
    mkdir ~#{node['ws-workshopbox']['user']['username']}/.ssh
    cp /root/secret/user/#{node['ws-workshopbox']['user']['username']}/id_rsa.pub ~#{node['ws-workshopbox']['user']['username']}/.ssh/authorized_keys
    cp /root/secret/user/#{node['ws-workshopbox']['user']['username']}/id_rsa.pub ~#{node['ws-workshopbox']['user']['username']}/.ssh/id_rsa.pub
    cp /root/secret/user/#{node['ws-workshopbox']['user']['username']}/id_rsa ~#{node['ws-workshopbox']['user']['username']}/.ssh/id_rsa
    chown -R #{node['ws-workshopbox']['user']['username']}.#{node['ws-workshopbox']['user']['username']} ~#{node['ws-workshopbox']['user']['username']}/.ssh
    chmod -R go-rwsx ~#{node['ws-workshopbox']['user']['username']}/.ssh
  EOC
  not_if do File.exist?(node['ws-workshopbox']['user']['home'] + '/.ssh') end
end

%w(.bash_logout .bashrc .dmrc .profile .xinputrc).each do |f|
  cookbook_file node['ws-workshopbox']['user']['home'] + '/' + f do
    owner node['ws-workshopbox']['user']['username']
    group node['ws-workshopbox']['user']['username']
    mode 00644
  end
end

%w(.config .gconf .local).each do |d|
  directory node['ws-workshopbox']['user']['home'] + '/' + d do
    owner node['ws-workshopbox']['user']['username']
    group node['ws-workshopbox']['user']['username']
    mode 00755
  end
end

%w(dconf gnome-session gtk-3.0 update-notifier upstart).each do |d|
  directory node['ws-workshopbox']['user']['home'] + '/.config/' + d do
    owner node['ws-workshopbox']['user']['username']
    group node['ws-workshopbox']['user']['username']
    mode 00755
  end
end

%w(user-dirs.dirs user-dirs.locale).each do |f|
  cookbook_file node['ws-workshopbox']['user']['home'] + '/.config/' + f do
    owner node['ws-workshopbox']['user']['username']
    group node['ws-workshopbox']['user']['username']
    mode 00644
  end
end

cookbook_file node['ws-workshopbox']['user']['home'] + '/.config/dconf/user' do
  owner node['ws-workshopbox']['user']['username']
  group node['ws-workshopbox']['user']['username']
  mode 00644
end

template node['ws-workshopbox']['user']['home'] + '/.config/gtk-3.0/bookmarks' do
  owner node['ws-workshopbox']['user']['username']
  group node['ws-workshopbox']['user']['username']
  mode 00644
end

template '/etc/lightdm/lightdm.conf'

bash 'setup git' do
  user node['ws-workshopbox']['user']['username']
  group node['ws-workshopbox']['user']['username']
  environment ({'HOME' => node['ws-workshopbox']['user']['home'], 'USER' => node['ws-workshopbox']['user']['username']})
  code <<-EOC
    git config --global user.email "#{node['ws-workshopbox']['user']['email']}"
    git config --global user.name "#{node['ws-workshopbox']['user']['fullname']}"
  EOC
end

cookbook_file node['ws-workshopbox']['user']['home'] + '/.ssh/config' do
  user node['ws-workshopbox']['user']['username']
  group node['ws-workshopbox']['user']['username']
  mode 0600
end
