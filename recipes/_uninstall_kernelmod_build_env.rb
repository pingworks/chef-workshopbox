#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

["linux-headers-#{node['uname']}", 'build-essential', 'dkms'].each do |pkg|
  package pkg do
    action :remove
  end
end
