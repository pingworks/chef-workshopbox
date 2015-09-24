#
# Cookbook Name:: wsbox-base
# Recipe:: default
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

bash 'set_editor_vim_root' do
  code <<-EOF
  echo 'export EDITOR=vi' >> .bashrc
  EOF
  not_if 'grep \'EDITOR=vi\' /root/.bashrc', 'user' => 'root'
end

include_recipe 'ohai'

#include_recipe 'wsbox-base::hostsfile'
#include_recipe 'wsbox-base::sources_list'
#include_recipe 'wsbox-base::base_packages'
#include_recipe 'wsbox-base::gnome_desktop'

#include_recipe 'wsbox-base::reinstall_guest_additons'
include_recipe 'wsbox-base::personalize'
