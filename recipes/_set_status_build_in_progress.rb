#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#


directory '/var/run/workshopbox' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

directory '/etc/workshopbox' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

template '/var/run/workshopbox/status' do
  variables({
    :status => 'build_in_progress:' + run_context.cookbook_collection['workshopbox'].metadata.version
  })
end
