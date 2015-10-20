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
  
end
