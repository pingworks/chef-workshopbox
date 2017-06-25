#
# Cookbook Name:: workshopbox
# Recipe:: _install_firefox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

if node['workshopbox']['tweak']['install_gnome_desktop'] == true
  package 'firefox'
  package 'xul-ext-ubufox'
end
