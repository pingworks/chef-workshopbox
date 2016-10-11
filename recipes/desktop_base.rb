#
# Cookbook Name:: workshopbox
# Recipe:: desktop
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

cookbook_file '/etc/default/locale' do
  source 'default_locale'
  owner 'root'
  group 'root'
  mode 00644
end

begin
  include_recipe "workshopbox::_install_#{node['workshopbox']['desktop']}_desktop"
rescue Chef::Exceptions::RecipeNotFound
  raise Chef::Exceptions::RecipeNotFound, 'The desktop flavor ' \
      "`#{node['workshopbox']['desktop']}' is not supported by " \
      'this cookbook!'
end

include_recipe 'workshopbox::_reinstall_guest_additions'
