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

  unless node['workshopbox']['precloned_githubrepos'].empty?
    directory "/home/#{username}/workspace" do
      owner username
      group username
      mode 00755
      recursive true
    end

    node['workshopbox']['precloned_githubrepos'].each do |pw_repo|
      bash "syncing gitrepo #{pw_repo} for user #{username}" do
        user username
        group username
        environment ({ 'HOME' => "/home/#{username}", 'USER' => username })
        code <<-EOC
          if [ ! -d /home/#{username}/workspace/#{pw_repo} ];then
            mkdir /home/#{username}/workspace/#{pw_repo}
          fi
          rsync -avx /var/lib/workshopbox/github/#{pw_repo}/ /home/#{username}/workspace/#{pw_repo}/
          chown -R #{username}.#{username} /home/#{username}/workspace/#{pw_repo}
        EOC
      end
    end
  end

  unless node['workshopbox']['precloned_githubcookbooks'].empty?
    directory "/home/#{username}/workspace/cookbooks/" do
      owner username
      group username
      mode 00755
      recursive true
    end
    node['workshopbox']['precloned_githubcookbooks'].each do |pw_repo|
      bash "syncing gitrepo #{pw_repo} for user #{username}" do
        user username
        group username
        environment ({ 'HOME' => "/home/#{username}", 'USER' => username })
        code <<-EOC
          if [ ! -d /home/#{username}/workspace/cookbooks/#{pw_repo} ];then
            mkdir /home/#{username}/workspace/cookbooks/#{pw_repo}
          fi
          rsync -avx /var/lib/workshopbox/github/#{pw_repo}/ /home/#{username}/workspace/cookbooks/#{pw_repo}/
          chown -R #{username}.#{username} /home/#{username}/workspace/cookbooks/#{pw_repo}
        EOC
      end
    end
  end
end
