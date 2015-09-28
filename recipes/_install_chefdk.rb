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

bash 'setup chefdk for root' do
  user 'root'
  cwd '/root'
  environment ({'HOME' => '/root', 'USER' => 'root' })
  code <<-EOC
    echo 'eval "$(chef shell-init bash)"' >> /root/.profile
  EOC
  not_if "grep 'chef shell-init bash'  /root/.profile"
end

# install some essential gems
node['ws-workshopbox']['preinstalled_gems'].each do |g|
  gem_package g do
    gem_binary '/opt/chefdk/embedded/bin/gem'
    options('--no-document --no-user-install --install-dir /opt/chefdk/embedded/lib/ruby/gems/2.1.0')
    action :install
  end
end

Dir.foreach(node['ws-workshopbox']['secret-service']['client']['repo'] + '/user') do |username|
  next if username == '.' or username == '..'
  bash 'setup chefdk for user ' + username do
    user username
    cwd "/home/#{username}"
    environment ({'HOME' => "/home/#{username}", 'USER' => username})
    code <<-EOC
      echo 'eval "$(chef shell-init bash)"' >> /home/#{username}/.profile
    EOC
    not_if "grep 'chef shell-init bash'  /home/#{username}/.profile"
  end

  # clone https://github.com/pingworks/chef-ws-base.git
  bash "git clone /home/#{username}/workspace/cookbooks/#{node['ws-workshopbox']['kitchen-docker']['testcookbook']['name']}" do
    user username
    group username
    code <<-EOC
      if [ ! -d /home/#{username}/workspace/cookbooks/#{node['ws-workshopbox']['kitchen-docker']['testcookbook']['name']} ];then
        cd "/home/#{username}/workspace/cookbooks"
        git clone #{node['ws-workshopbox']['kitchen-docker']['testcookbook']['url']}
      fi
    EOC
  end
end

# docker pull pingworks/docker-ws-baseimg
bash 'pull docker ws baseimg' do
  user node['ws-workshopbox']['adminuser']['username']
  group 'adm'
  environment ({'HOME' => node['ws-workshopbox']['adminuser']['home'], 'USER' => node['ws-workshopbox']['adminuser']['username']})
  code <<-EOC
    docker pull #{node['ws-workshopbox']['kitchen-docker']['baseimg']}
  EOC
end
