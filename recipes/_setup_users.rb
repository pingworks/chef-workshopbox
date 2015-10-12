#
# Cookbook Name:: ws-workshopbox
# Recipe:: _setup_user
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

# if no secret-service repo is found, create a dummy one with user testuser only
unless File.directory?(node['ws-workshopbox']['secret-service']['client']['repo'] + '/user')
  userlist = %w(testuser)
  userlist.each do |username|
    directory "#{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/.ssh" do
      owner node['secret-service']['client']['user']
      group node['secret-service']['client']['user']
      mode 00700
      recursive true
    end

    cookbook_file "#{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/.ssh/id_rsa" do
      source 'vagrant_id_rsa'
      owner node['secret-service']['client']['user']
      group node['secret-service']['client']['user']
      mode 00600
    end

    cookbook_file "#{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/.ssh/id_rsa.pub" do
      source 'vagrant_id_rsa.pub'
      owner node['secret-service']['client']['user']
      group node['secret-service']['client']['user']
      mode 00600
    end

    cookbook_file "#{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/.ssh/authorized_keys" do
      source 'vagrant_id_rsa.pub'
      owner node['secret-service']['client']['user']
      group node['secret-service']['client']['user']
      mode 00600
    end

    bash "Mocking secrets for user #{username}" do
      code <<-EOC
        echo #{username}@example.com > #{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/email
        echo "#{username}" > #{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/password
        echo "#{username}" > #{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/firstname
        echo "#{username}" > #{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/lastname
        chown -R #{node['secret-service']['client']['user']}.#{node['secret-service']['client']['user']} #{node['ws-workshopbox']['secret-service']['client']['repo']}
        find #{node['ws-workshopbox']['secret-service']['client']['repo']} -type d -exec chmod 0700 \\{\\} \\;
        find #{node['ws-workshopbox']['secret-service']['client']['repo']} -type f -exec chmod 0600 \\{\\} \\;
      EOC
    end
  end
end

Dir.foreach(node['ws-workshopbox']['secret-service']['client']['repo'] + '/user') do |username|
  next if username == '.' || username == '..'
  bash 'create user' + username do
    code <<-EOC
      useradd #{username} --create-home --shell /bin/bash --groups adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare
      echo #{username}:$(< #{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/password) | chpasswd
    EOC
    not_if { File.exist?("/home/#{username}") }
  end

  bash 'create users ' + username + ' .ssh settings' do
    code <<-EOC
      mkdir /home/#{username}/.ssh
      cp #{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/.ssh/authorized_keys /home/#{username}/.ssh/authorized_keys
      cp #{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/.ssh/id_rsa.pub /home/#{username}/.ssh/id_rsa.pub
      cp #{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/.ssh/id_rsa /home/#{username}/.ssh/id_rsa
      chown -R #{username}.#{username} /home/#{username}/.ssh
      chmod -R go-rwsx /home/#{username}/.ssh
    EOC
    not_if { File.exist?("/home/#{username}/.ssh/id_rsa") }
  end

  bash 'append public key to vagrant authorized_keys' do
    code <<-EOC
      cat /home/#{username}/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    EOC
    not_if "grep \"$(cat /home/#{username}/.ssh/id_rsa.pub | cut -d' ' -f3)\" /home/vagrant/.ssh/authorized_keys"
  end

  %w(.vimrc .bash_logout .bashrc .dmrc .profile .xinputrc).each do |f|
    cookbook_file "/home/#{username}/#{f}" do
      owner username
      group username
      mode 00644
    end
  end

  %w(.config .gconf .local).each do |d|
    directory "/home/#{username}/#{d}" do
      owner username
      group username
      mode 00755
    end
  end

  %w(dconf gnome-session gtk-3.0 update-notifier upstart).each do |d|
    directory "/home/#{username}/.config/#{d}" do
      owner username
      group username
      mode 00755
    end
  end

  %w(user-dirs.dirs user-dirs.locale).each do |f|
    cookbook_file "/home/#{username}/.config/#{f}" do
      owner username
      group username
      mode 00644
    end
  end

  cookbook_file "/home/#{username}/.config/dconf/user" do
    owner username
    group username
    mode 00644
  end

  template "/home/#{username}/.config/gtk-3.0/bookmarks" do
    owner username
    group username
    mode 00644
    variables(
      username: username
    )
  end

  bash 'setup git' do
    user username
    group username
    environment ({ 'HOME' => "/home/#{username}", 'USER' => username })
    code <<-EOC
      git config --global user.email "$(cat #{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/email)"
      git config --global user.name "$(cat #{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/firstname) $(cat #{node['ws-workshopbox']['secret-service']['client']['repo']}/user/#{username}/lastname)"
    EOC
  end

  cookbook_file "/home/#{username}/.ssh/config" do
    owner username
    group username
    mode 0600
  end

  directory "/home/#{username}/workspace/cookbooks/" do
    owner username
    group username
    mode 00755
    recursive true
  end

  directory "/home/#{username}/.mofa" do
    owner username
    group username
    mode 00755
    recursive true
    action :create
  end

  template "/home/#{username}/.mofa/config.yml" do
    source 'config.yml.user.erb'
    owner username
    group username
    mode 00644
    variables(
      username: username
    )
  end

  directory "/home/#{username}/.wsbox/cookbooks/" do
    owner username
    group username
    mode 00755
    recursive true
  end

  # Checking out read-only cookbooks
  %w(chef-ws-workshopbox chef-secret-service-client).each do |pw_repo|
    bash "git clone #{pw_repo}" do
      user username
      group username
      environment ({ 'HOME' => "/home/#{username}", 'USER' => username })
      code <<-EOC
        if [ ! -d /home/#{username}/.wsbox/cookbooks/#{pw_repo} ];then
          cd /home/#{username}/.wsbox/cookbooks
          git clone https://github.com/pingworks/#{pw_repo}.git
        else
          cd /home/#{username}/.wsbox/cookbooks/#{pw_repo}
          git pull
        fi
      EOC
    end
  end

  node['ws-workshopbox']['precloned_cookbooks'].each do |pw_repo|
    bash "git clone #{pw_repo}" do
      user username
      group username
      environment ({ 'HOME' => "/home/#{username}", 'USER' => username })
      code <<-EOC
        if [ ! -d /home/#{username}/workspace/cookbooks/#{pw_repo} ];then
          cd /home/#{username}/workspace/cookbooks
          git clone https://github.com/pingworks/#{pw_repo}.git
        else
          cd /home/#{username}/workspace/cookbooks/#{pw_repo}
          git pull
        fi
      EOC
    end
  end
end
