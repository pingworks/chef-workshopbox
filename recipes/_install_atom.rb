#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

# apt_repository 'atom-ppa' do
#   uri 'http://ppa.launchpad.net/webupd8team/atom/ubuntu'
#   distribution node['lsb']['codename']
#   components ['main']
#   keyserver 'keyserver.ubuntu.com'
#   key 'EEA14886'
# end
# apt_package 'atom' do
#   action :install
#   version '1.0.19-1~webupd8~0'
# end

%w(gconf2 libpython-stdlib libpython2.7-minimal libpython2.7-stdlib python python-minimal python2.7 python2.7-minimal xdg-utils gir1.2-gnomekeyring-1.0).each do |pkg|
  package pkg
end

atom_pkg = 'atom_1.0.19-1~webupd8~0_amd64.deb'
remote_file '/usr/local/src/' + atom_pkg do
  source 'http://depot.pingworks.net/atom/' + atom_pkg
  owner 'root'
  group 'root'
end

bash 'install atom' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  if [ -z $(dpkg -s atom | grep '^Version: 1\.0\.19.*') ];then
    dpkg -i /usr/local/src/#{atom_pkg}
  fi
  EOH
end
