#
# Cookbook Name:: workshopbox
# Recipe:: desktop
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

begin
  include_recipe "workshopbox::_install_#{node['workshopbox']['desktop']}_desktop"
rescue Chef::Exceptions::RecipeNotFound
  raise Chef::Exceptions::RecipeNotFound, 'The desktop flavor ' \
      "`#{node['workshopbox']['desktop']}' is not supported by " \
      'this cookbook!'
end

# Disabled for now
# include_recipe 'workshopbox::_reinstall_guest_additions'
