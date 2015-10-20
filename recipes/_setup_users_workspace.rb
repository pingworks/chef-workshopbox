#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_cheftooling
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

Dir.foreach(node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
  next if username == '.' || username == '..'

  directory "/home/#{username}/workspace/cookbooks/" do
    owner username
    group username
    mode 00755
    recursive true
  end

  node['workshopbox']['precloned_githubrepos'].each do |pw_repo|
    bash "git clone #{pw_repo}" do
      user username
      group username
      environment ({ 'HOME' => "/home/#{username}", 'USER' => username })
      code <<-EOC
        if [ ! -d /home/#{username}/workspace/cookbooks/#{pw_repo} ];then
          cd /home/#{username}/workspace/cookbooks
          git clone /var/lib/workshopbox/github/#{pw_repo}.git
          cd #{pw_repo}
          if [ ! -z "$(git remote -v)" ];then git remote remove origin;fi
          git remote add origin https://github.com/pingworks/#{pw_repo}.git
          git pull origin master
          git branch --set-upstream-to=origin/master master
        else
          cd /home/#{username}/workspace/cookbooks/#{pw_repo}
          git pull
        fi
      EOC
    end
  end
end
