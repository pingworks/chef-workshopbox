#
# Cookbook Name:: wsbox-base
# Recipe:: _install_atom
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

remote_file node['wsbox-base']['adminuser']['home'] + '/VBoxGuestAdditions_' + node['vboxversion'] + '.iso' do
  source "http://#{node['wsbox-base']['mirror']['vbox']}/virtualbox/#{node['vboxversion']}/VBoxGuestAdditions_#{node['vboxversion']}.iso"
  user node['wsbox-base']['adminuser']['username']
  group node['wsbox-base']['adminuser']['username']
end

[ 'dkms', 'build-essential', "linux-headers-#{node['uname']}"].each do |pkg|
  package pkg
end

bash 'install VBoxGuestAdditions' do
  code <<-EOC
    [ ! -d /tmp/vbox ] && mkdir /tmp/vbox
    mount -o loop #{node['wsbox-base']['adminuser']['home']}/VBoxGuestAdditions_#{node['vboxversion']}.iso /tmp/vbox
    bash /tmp/vbox/VBoxLinuxAdditions.run
    umount /tmp/vbox
    rmdir /tmp/vbox
  EOC
end

["linux-headers-#{node['uname']}", 'build-essential', 'dkms'].each do |pkg|
  package pkg do
    action :remove
  end
end
