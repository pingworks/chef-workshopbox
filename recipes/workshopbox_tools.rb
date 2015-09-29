#
# Cookbook Name:: ws-workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

package 'git'
package 'vim'

directory '/opt/workshopbox/bin' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

directory '/opt/workshopbox/etc' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

directory '/opt/workshopbox/lib/cookbooks' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

directory '/opt/workshopbox/lib/tpl' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

cb = run_context.cookbook_collection[cookbook_name]
# Loop over the array of files
cb.manifest['files'].each do |cbf|
  next if cbf !~ /^wsbox-.*\.sh/
  # cbf['path'] is relative to the cookbook root, eg
  #   'files/default/foo.txt'
  # cbf['name'] strips the first two directories, eg
  #   'foo.txt'
  filename = cbf['name']
  filename_short = cbf['name'].sub('.sh','')
  cookbook_file "/opt/workshopbox/bin/#{filename}" do
    source filename
    mode 00755
  end

  link "/user/local/bin/#{filename_short}" do
    to "/opt/workshopbox/bin/#{filename}"
  end
end

template '/opt/workshopbox/lib/tpl/.kitchen.yml.tpl' do
  owner 'root'
  group 'root'
  mode 00644
end

%w(chef-ws-workshopbox chef-secret-service-client).each do |pw_repo|
  bash "git clone #{pw_repo}" do
    user 'root'
    group 'root'
    code <<-EOC
      if [ ! -d /opt/workshopbox/lib/cookbooks/#{pw_repo} ];then
        cd /opt/workshopbox/lib/cookbooks
        git clone https://github.com/pingworks/#{pw_repo}.git
      fi
    EOC
  end
end

directory '/root/.mofa' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

template '/root/.mofa/config.yml' do
  owner 'root'
  group 'root'
  mode 00644
end

template '/opt/workshopbox/etc/hostlist.json' do
  owner 'root'
  group 'root'
  mode 00644
end
