#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

remote_file '/usr/local/src/chefdk.deb' do
  source node['workshopbox']['download']['chefdk']['url']
  checksum node['workshopbox']['download']['chefdk']['sha256']
end

bash 'install chefdk' do
  code <<-EOC
    dpkg -i /usr/local/src/chefdk.deb
  EOC
  not_if 'dpkg -s chefdk'
end

# install some essential gems
node['workshopbox']['preinstalled_gems'].each do |gpkg|
  (g, v) = gpkg.split('@')
  gem_package g do
    gem_binary '/opt/chefdk/embedded/bin/gem'
    options('--force --no-document --no-user-install --install-dir /opt/chefdk/embedded/lib/ruby/gems/2.1.0')
    version v
    action :install
  end
end
