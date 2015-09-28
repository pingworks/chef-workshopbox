#
# Cookbook Name:: ws-workshopbox
# Recipe:: default
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

# make sure that no installation key is still active
cookbook_file '/tmp/id_rsa'

include_recipe 'ws-workshopbox::_set_status_build_in_progress'

include_recipe 'ohai'
include_recipe 'ws-workshopbox::hostsfile'
include_recipe 'ws-workshopbox::sources_list'

%w(git vim less htop).each do |pkg|
  package pkg
end

include_recipe 'ws-workshopbox::_setup_root'
#include_recipe 'ws-workshopbox::desktop_base'
#include_recipe 'ws-workshopbox::desktop_personalized'

#include_recipe 'ws-workshopbox::workshopbox_tools'

include_recipe 'ws-workshopbox::_set_status_build_success'
