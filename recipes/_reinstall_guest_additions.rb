#
# Cookbook Name:: ws-workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

# a handy tool to detect the running vbox version
cookbook_file 'detect_vboxversion' do
  path '/usr/local/bin/detect_vboxversion'
  mode 0755
end

remote_file node['ws-workshopbox']['adminuser']['home'] + '/VBoxGuestAdditions_' + node['vboxversion'] + '.iso' do
  source "http://#{node['ws-workshopbox']['mirror']['vbox']}/virtualbox/#{node['vboxversion']}/VBoxGuestAdditions_#{node['vboxversion']}.iso"
  user node['ws-workshopbox']['adminuser']['username']
  group node['ws-workshopbox']['adminuser']['username']
  not_if "lsmod | grep -i vboxvideo"
end


[ 'dkms', 'build-essential', "linux-headers-#{node['uname']}"].each do |pkg|
  package pkg do
    not_if "lsmod | grep -i vboxvideo"
  end
end

bash 'install VBoxGuestAdditions' do
  code <<-EOC
    [ ! -d /tmp/vbox ] && mkdir /tmp/vbox
    mount -o loop #{node['ws-workshopbox']['adminuser']['home']}/VBoxGuestAdditions_#{node['vboxversion']}.iso /tmp/vbox
    bash /tmp/vbox/VBoxLinuxAdditions.run
    umount /tmp/vbox
    rmdir /tmp/vbox
  EOC
  not_if "lsmod | grep -i vboxvideo"
end

["linux-headers-#{node['uname']}", 'build-essential', 'dkms'].each do |pkg|
  package pkg do
    action :remove
    not_if "lsmod | grep -i vboxvideo"
  end
end
