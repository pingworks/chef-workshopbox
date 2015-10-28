#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

node['workshopbox']['base_pkgs'].each do |pkg|
  package pkg
end
