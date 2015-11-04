#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_cheftooling
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

Dir.foreach(node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
  next if username == '.' || username == '..' || node['workshopbox']['secret_service']['client']['ignore_users'].include?(username)

  directory "/home/#{username}/.wsbox/cookbooks/" do
    owner username
    group username
    mode 00755
    recursive true
  end

  # Checking out read-only cookbooks
  node['workshopbox']['wsboxinternal']['githubrepos'].each do |pw_repo|
    bash "git clone #{pw_repo}" do
      user username
      group username
      environment ({ 'HOME' => "/home/#{username}", 'USER' => username })
      code <<-EOC
        if [ ! -d /home/#{username}/.wsbox/cookbooks/#{pw_repo} ];then
          mkdir /home/#{username}/.wsbox/cookbooks/#{pw_repo}
        fi
        rsync -avx /var/lib/workshopbox/github/#{pw_repo}/ /home/#{username}/.wsbox/cookbooks/#{pw_repo}/
        chown -R #{username}.#{username} /home/#{username}/.wsbox/cookbooks/#{pw_repo}
      EOC
    end
  end
end
