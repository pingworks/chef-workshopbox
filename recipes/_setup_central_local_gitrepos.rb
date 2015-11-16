#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
directory '/var/lib/workshopbox/github' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

githubrepos = node['workshopbox']['wsboxinternal']['githubrepos'] | node['workshopbox']['precloned_githubrepos']

githubrepos.each do |pw_repo|
  bash "git clone #{pw_repo}" do
    code <<-EOC
      if [ ! -d /var/lib/workshopbox/github/#{pw_repo} ];then
        cd /var/lib/workshopbox/github
        git clone https://github.com/pingworks/#{pw_repo}.git
      else
        cd /var/lib/workshopbox/github/#{pw_repo}
        git pull
      fi
    EOC
  end

  next if pw_repo != 'chef-workshopbox'
end
