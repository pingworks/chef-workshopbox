#
# Cookbook Name:: wsbox_base
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

include_recipe 'wsbox_base::hostsfile'
include_recipe 'wsbox_base::sources_list'
include_recipe 'wsbox_base::base_packages'
include_recipe 'wsbox_base::gnome_desktop'

include_recipe 'wsbox_base::personalize'

Chef::Log.info("Ohai plugin_path #{Ohai::Config[:plugin_path]}")
Chef::Log.info("Node vboxversion is #{node['vboxversion']}")
