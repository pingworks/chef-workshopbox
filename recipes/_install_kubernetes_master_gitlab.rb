#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_kubernetes_master'] == true
  %w(gitlab postgresql redis registry).each do |folder|
    directory "/data/nfs/infra/gitlab/#{folder}" do
      owner 'root'
      group 'root'
      mode 00777
      recursive true
      action :create
    end
  end

  cookbook_file '/root/.kubesetup/registry.crt'
  cookbook_file '/root/.kubesetup/registry.key'

  bash 'setup tls secret' do
    user 'root'
    cwd '/tmp'
    environment 'HOME' => '/root'
    code <<-EOH
      kubectl create --namespace=infra -f secret generic registry-tls-secret \
            --from-file=/root/.kubesetup/registry.crt \
            --from-file=$REGDIR/root/.kubesetup/registry.key
    EOH
    not_if 'kubectl --namespace=infra describe secret registry-tls-secret', environment: { 'HOME' => '/root' }
  end
end
