#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_kubernetes_client'] == true
  package 'apt-transport-https'

  bash 'add kubernetes repo' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
      curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    EOH
  end

  cookbook_file '/etc/apt/sources.list.d/kubernetes.list'

  bash 'apt-get update' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
      apt-get update
    EOH
  end

  package 'kubectl' do
    version '1.6.2-00'
  end
end
