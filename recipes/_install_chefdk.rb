#
# Cookbook Name:: ws-workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

remote_file '/usr/local/src/chefdk.deb' do
  source node['ws-workshopbox']['download']['chefdk']['url']
  checksum node['ws-workshopbox']['download']['chefdk']['sha256']
end

bash 'install chefdk' do
  code <<-EOC
    dpkg -i /usr/local/src/chefdk.deb
  EOC
  not_if 'dpkg -s chefdk'
end

bash 'setup chefdk for user' do
  user node['ws-workshopbox']['user']['username']
  cwd node['ws-workshopbox']['user']['home']
  environment ({'HOME' => node['ws-workshopbox']['user']['home'], 'USER' => node['ws-workshopbox']['user']['username']})
  code <<-EOC
    echo 'eval "$(chef shell-init bash)"' >> #{node['ws-workshopbox']['user']['home']}/.profile
  EOC
  not_if "grep 'chef shell-init bash'  #{node['ws-workshopbox']['user']['home']}/.profile"
end

bash 'setup chefdk for root' do
  user 'root'
  cwd '/root'
  environment ({'HOME' => '/root', 'USER' => 'root' })
  code <<-EOC
    echo 'eval "$(chef shell-init bash)"' >> /root/.profile
  EOC
  not_if "grep 'chef shell-init bash'  /root/.profile"
end

%w(kitchen-docker mofa).each do |gem|
  gem_package gem
end

directory node['ws-workshopbox']['user']['home'] + '/workspace/cookbooks/' do
  owner node['ws-workshopbox']['user']['username']
  group node['ws-workshopbox']['user']['username']
  mode 00755
  recursive true
end

# clone docker-ws-baseimage
git node['ws-workshopbox']['user']['home'] + '/workspace/docker-ws-baseimg' do
  repository 'https://github.com/pingworks/docker-ws-baseimg.git'
  revision 'master'
  action :sync
end

# docker build
bash 'build docker ws baseimg' do
  user node['ws-workshopbox']['user']['username']
  cwd node['ws-workshopbox']['user']['home'] + '/workspace/docker-ws-baseimg'
  environment ({'HOME' => node['ws-workshopbox']['user']['home'], 'USER' => node['ws-workshopbox']['user']['username']})
  code <<-EOC
    docker build .
  EOC
end

# clone chef-wsbox-kitchen-docker-test
git node['ws-workshopbox']['user']['home'] + '/workspace/cookbooks/chef-wsbox-kitchen-docker-test' do
  repository 'https://github.com/pingworks/chef-wsbox-kitchen-docker-test.git'
  revision 'master'
  action :sync
end
