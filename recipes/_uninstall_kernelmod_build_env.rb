#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

if node['workshopbox']['tweak']['install_kernmod_build_env'] == true
  ["linux-headers-#{node['uname']}", 'build-essential', 'dkms'].each do |pkg|
    package pkg do
      action :remove
    end
  end
end
