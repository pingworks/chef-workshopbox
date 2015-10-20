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

  bash 'create user' + username do
    code <<-EOC
      useradd #{username} --create-home --shell /bin/bash --groups adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare
      echo #{username}:$(< #{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/password_sha512) | chpasswd -e
    EOC
    not_if { File.exist?("/home/#{username}") }
  end

  bash 'create users ' + username + ' .ssh settings' do
    code <<-EOC
      mkdir /home/#{username}/.ssh
      cp #{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/.ssh/authorized_keys /home/#{username}/.ssh/authorized_keys
      cp #{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/.ssh/id_rsa.pub /home/#{username}/.ssh/id_rsa.pub
      cp #{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/.ssh/id_rsa /home/#{username}/.ssh/id_rsa
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
end
