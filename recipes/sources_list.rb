#
# Cookbook Name:: workshopbox
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

# import some missing gpg keys
%w(3B4FE6ACC0B21F32 40976EAF437D05B5).each do |k|
  bash 'import gpg key' + k do
    code <<-EOC
      gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv #{k}
      gpg --export --armor #{k}| apt-key add -
    EOC
  end
end

bash 'refresh apt sources' do
  code <<-EOC
  apt-get update
  EOC
end
