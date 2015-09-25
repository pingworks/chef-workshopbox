#
# Cookbook Name:: ws-workshopbox
# Recipe:: default
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

include_recipe 'ohai'
include_recipe 'ws-workshopbox::hostsfile'
include_recipe 'ws-workshopbox::sources_list'

%w(git vim less htop).each do |pkg|
  package pkg
end

bash 'set_editor_vim_root' do
  code <<-EOF
  echo 'export EDITOR=vim' >> /root/.bashrc
  EOF
  not_if 'grep \'EDITOR=vim\' /root/.bashrc', 'user' => 'root'
end

include_recipe 'ws-workshopbox::desktop_base'
include_recipe 'ws-workshopbox::desktop_personalized'
