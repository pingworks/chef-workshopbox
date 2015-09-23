#
# Cookbook Name:: wsbox_base
# Recipe:: personalize
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

%w(Documents Music Pictures Public Templates Videos).each do |folder|
  directory node['wsbox_base']['user']['home'] + '/' + folder do
    action :delete
  end
end

include_recipe 'wsbox_base::_install_vbox_guest_additions'



