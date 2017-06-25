#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
['dkms', 'build-essential', "linux-headers-#{node['uname']}"].each do |pkg|
  package pkg do
    action :install
  end
end
