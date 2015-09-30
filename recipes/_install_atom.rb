#
# Cookbook Name:: ws-workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

bash 'install atom editor' do
  code <<-EOC
    add-apt-repository -y ppa:webupd8team/atom
    apt-get install -y atom
  EOC
end

cookbook_file "/var/tmp/atom-config_0.1.0.tar.gz" do
  owner 'root'
  group 'root'
  mode 00644
end

Dir.foreach(node['ws-workshopbox']['secret-service']['client']['repo'] + '/user') do |username|
  next if username == '.' or username == '..'
  bash 'untar atom config' do
    user username
    group username
    environment ({'HOME' => "/home/#{username}", 'USER' => username })
    code <<-EOC
      cd /home/#{username}
      tar xvfz /var/tmp/atom-config_0.1.0.tar.gz
      chown -R #{username}.#{username} /home/#{username}/.atom
    EOC
  end
end
