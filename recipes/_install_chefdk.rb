#
# Cookbook Name:: wsbox-base
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

remote_file '/usr/local/src/chefdk.deb' do
  source node['wsbox-base']['download']['chefdk']['url']
  checksum node['wsbox-base']['download']['chefdk']['sha256']
end

bash 'install chefdk' do
  code <<-EOC
    dpkg -i /usr/local/src/chefdk.deb
  EOC
  not_if 'dpkg -s chefdk'
end

bash 'setup chefdk for user' do
  user node['wsbox-base']['user']['username']
  cwd node['wsbox-base']['user']['home']
  environment ({'HOME' => node['wsbox-base']['user']['home'], 'USER' => node['wsbox-base']['user']['username']})
  code <<-EOC
    echo 'eval "$(chef shell-init bash)"' >> #{node['wsbox-base']['user']['home']}/.profile
  EOC
  not_if "grep 'chef shell-init bash'  #{node['wsbox-base']['user']['home']}/.profile"
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

directory node['wsbox-base']['user']['home'] + '/workspace/cookbooks/' do
  owner node['wsbox-base']['user']['username']
  group node['wsbox-base']['user']['username']
  mode 00755
  recursive true
end

# clone docker-ws-baseimage
git node['wsbox-base']['user']['home'] + '/workspace/docker-ws-baseimg' do
  repository 'https://github.com/pingworks/docker-ws-baseimg.git'
  revision 'master'
  action :sync
end

# docker build
bash 'build docker ws baseimg' do
  user node['wsbox-base']['user']['username']
  cwd node['wsbox-base']['user']['home'] + '/workspace/docker-ws-baseimg'
  environment ({'HOME' => node['wsbox-base']['user']['home'], 'USER' => node['wsbox-base']['user']['username']})
  code <<-EOC
    docker build .
  EOC
end

# clone chef-wsbox-kitchen-docker-test
git node['wsbox-base']['user']['home'] + '/workspace/cookbooks/chef-wsbox-kitchen-docker-test' do
  repository 'https://github.com/pingworks/chef-wsbox-kitchen-docker-test.git'
  revision 'master'
  action :sync
end
