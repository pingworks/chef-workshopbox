#
# Cookbook Name:: workshopbox
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

if node['workshopbox']['tweak']['reinstall_guest_additions'] == true
  remote_file node['workshopbox']['adminuser']['home'] + '/VBoxGuestAdditions_' + node['vboxversion'] + '.iso' do
    source "http://#{node['workshopbox']['mirror']['vbox']}/virtualbox/#{node['vboxversion']}/VBoxGuestAdditions_#{node['vboxversion']}.iso"
    user node['workshopbox']['adminuser']['username']
    group node['workshopbox']['adminuser']['username']
    #not_if "lsmod | grep -i vboxvideo"
  end

  bash 'install VBoxGuestAdditions' do
    code <<-EOC
      [ ! -d /tmp/vbox ] && mkdir /tmp/vbox
      mount -o loop #{node['workshopbox']['adminuser']['home']}/VBoxGuestAdditions_#{node['vboxversion']}.iso /tmp/vbox
      bash /tmp/vbox/VBoxLinuxAdditions.run
      umount /tmp/vbox
      rmdir /tmp/vbox
    EOC
    #not_if "lsmod | grep -i vboxvideo"
  end
end
