#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_kubernetes_master'] == true
  include_recipe 'apt'

  ['apt-transport-https', 'ca-certificates', "linux-image-extra-#{node['kernel']['release']}", 'linux-image-extra-virtual'].each do |pkg|
    package pkg
  end

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

  package %w(kubelet kubeadm kubectl kubernetes-cni) do
    version ["#{node['workshopbox']['kubernetes']['kubeversion']}-00", "#{node['workshopbox']['kubernetes']['kubeversion']}-00", "#{node['workshopbox']['kubernetes']['kubeversion']}-00", '0.5.1-00']
  end

  Chef::Log.info("Configuring Kubelet with cluster-dns #{node['workshopbox']['kubernetes']} ...")
  template '/etc/systemd/system/kubelet.service.d/10-kubeadm.conf' do
    owner 'root'
    group 'root'
    mode 00640
  end

  bash 'configuring clusterDNS into kubelet start configuration' do
    user 'root'
    code <<-EOH
      systemctl stop kubelet
      sleep 5
      systemctl daemon-reload
      sleep 2
      systemctl start kubelet
      sleep 5
    EOH
  end
  Chef::Log.info('kubelet configured.')

  %w(kubelet kubeadm kubectl kubernetes-cni).each do |p|
    bash 'set kubernetes packages on hold' do
      user 'root'
      cwd '/tmp'
      code <<-EOH
      apt-mark hold #{p}
      EOH
    end
  end

  bash 'make sure that workshobox uses kubernetes DNS' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
    rm -rf /etc/resolvconf/resolv.conf.d/*
    touch /etc/resolvconf/resolv.conf.d/base
    EOH
  end

  cookbook_file '/etc/resolvconf/resolv.conf.d/head'
end
