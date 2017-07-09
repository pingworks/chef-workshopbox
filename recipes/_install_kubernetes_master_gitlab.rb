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
      kubectl --namespace=infra create secret generic registry-tls-secret \
            --from-file=/root/.kubesetup/registry.crt \
            --from-file=$REGDIR/root/.kubesetup/registry.key
    EOH
    not_if 'kubectl --namespace=infra describe secret registry-tls-secret', environment: { 'HOME' => '/root' }
  end

  template '/root/.kubesetup/pv-gitlab.yaml'
  cookbook_file '/root/.kubesetup/pvc-gitlab.yaml'
  cookbook_file '/root/.kubesetup/statefulset-gitlab.yaml'
  cookbook_file '/root/.kubesetup/service-gitlab.yaml'

  bash 'setup statefulset gitlab' do
    user 'root'
    cwd '/tmp'
    environment 'HOME' => '/root'
    code <<-EOH
    for P in gitlab-gitlab gitlab-postgresql gitlab-redis; do
      if kubectl get pv | grep "^pv-${P} " >/dev/null;then
        echo "PV pv-${P} already exists - skipping..."
      else
        kubectl apply -f /root/.kubesetup/pv-gitlab.yaml
      fi
      if kubectl get pvc --namespace=infra | grep "^pvc-${P} " >/dev/null;then
        echo "PV pvc-${P} already exists - skipping..."
      else
        kubectl apply -f /root/.kubesetup/pvc-gitlab.yaml
      fi
    done
    kubectl create -f /root/.kubesetup/statefulset-gitlab.yaml
    kubectl apply -f /root/.kubesetup/service-gitlab.yaml
    EOH
    not_if 'kubectl --namespace=infra get statefulsets | grep "^gitlab "', environment: { 'HOME' => '/root' }
  end

end
