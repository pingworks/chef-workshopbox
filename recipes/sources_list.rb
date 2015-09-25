#
# Cookbook Name:: ws-workshopbox
# Recipe:: sources_list
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
cookbook_file 'apt-conf-11auto' do
  path '/etc/apt/apt.conf.d/11auto'
end

template '/etc/apt/sources.list'

file '/var/cache/apt/pkgcache.bin' do
  action :delete
end

file '/var/cache/apt/srcpkgcache.bin' do
  action :delete
end

bash 'refresh apt sources' do
  code <<-EOC
  apt-get update
  EOC
end