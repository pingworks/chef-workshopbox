#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_kubernetes_master'] == true
  include_recipe 'apt'

  directory '/root/kubesetup' do
    owner 'root'
    group 'root'
    mode 00755
    action :create
  end

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

  template '/root/kubesetup/overlay-network.yaml' do
    source 'weave-daemonset-k8s-1.6.yaml.erb'
    owner 'root'
    group 'root'
    mode 00644
  end

  bash 'Initializing Cluster' do
    user 'root'
    code <<-EOH
      echo 'Initializing Cluster...' >> /root/kubesetup/log
      rm -rf /var/lib/kubelet/*
      echo 'kubeadm init...' >> /root/kubesetup/log
      kubeadm init \
      --kubernetes-version v#{node['workshopbox']['kubernetes']['kubeversion']} \
      --service-cidr #{node['workshopbox']['kubernetes']['svccidr']}  \
      --service-dns-domain #{node['workshopbox']['kubernetes']['svcdomain']}  \
      | tee /root/kubesetup/kubeinit.out
      cat /root/kubesetup/kubeinit.out >> /root/kubesetup/log
      echo 'Waiting for pod kube-apiserver to come up...' >> /root/kubesetup/log
      I=0
      KUBEAPI_UP=0
      while [ $I -lt 60 -a $KUBEAPI_UP -eq 0 ];do
        if kubectl --kubeconfig /etc/kubernetes/admin.conf get pods --namespace=kube-system | grep kube-apiserver | grep '1/1' | grep 'Running' > /dev/null 2>&1;then
          KUBEAPI_UP=1
        fi
        sleep 1
        echo -n '.' >> /root/kubesetup/log
        I=$(expr $I + 1)
      done
      if [ $KUBEAPI_UP -eq 0 ];then
        echo 'kube-apiserver never came up!' >> /root/kubesetup/log
        exit 1
      fi
      kubectl --kubeconfig /etc/kubernetes/admin.conf taint nodes --all node-role.kubernetes.io/master-
    EOH
    not_if '[ -d /etc/kubernetes/pki ]'
  end

  bash 'allow pods to be created on master' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
      kubectl --kubeconfig /etc/kubernetes/admin.conf taint nodes --all node-role.kubernetes.io/master-
    EOH
  end

  bash 'set up overlay network' do
    user 'root'
    cwd '/root/kubesetup'
    code <<-EOH
    kubectl --kubeconfig /etc/kubernetes/admin.conf apply -f overlay-network.yaml
    echo 'Waiting for overlay network and after that kube-dns to come up...' >> /root/kubesetup/log
    I=0
    KUBEDNS_UP=0
    while [ $I -lt 180 -a $KUBEDNS_UP -eq 0 ];do
      if kubectl --kubeconfig /etc/kubernetes/admin.conf get pods --namespace=kube-system| grep kube-dns | grep '3/3';then
        KUBEDNS_UP=1
      fi
      sleep 1
      echo -n '.' >> /root/kubesetup/log
      I=$(expr $I + 1)
    done
    if [ $KUBEDNS_UP -eq 0 ];then
      echo 'kube-dns never came up!' >> /root/kubesetup/log
      exit 1
    fi
    echo 'overlay network and kube-dns up and running!' >> /root/kubesetup/log
    EOH
    not_if 'kubectl --kubeconfig /etc/kubernetes/admin.conf get pods --namespace=kube-system| grep kube-dns | grep "3/3"'
  end

  cookbook_file '/root/kubesetup/kubernetes-dashboard.yaml' do
    owner 'root'
    group 'root'
    mode 00644
  end

  bash 'deploy kubernetes dashboard' do
    user 'root'
    cwd '/root/kubesetup'
    code <<-EOH
    kubectl --kubeconfig /etc/kubernetes/admin.conf describe deployment kubernetes-dashboard --namespace=kube-system >/dev/null 2>&1 || (
      kubectl --kubeconfig /etc/kubernetes/admin.conf apply -f kubernetes-dashboard.yaml
    )
    I=0
    KUBEDASH_UP=0
    echo 'Waiting for kubernetes-dashboard to come up...' >> /root/kubesetup/log
    while [ $I -lt 180 -a $KUBEDASH_UP -eq 0 ];do
      if kubectl --kubeconfig /etc/kubernetes/admin.conf get pods --namespace=kube-system | grep kubernetes-dashboard | grep '1/1' | grep 'Running' > /dev/null 2>&1;then
        KUBEDASH_UP=1
      fi
      sleep 1
      echo -n '.' >> /root/kubesetup/log
      I=$(expr $I + 1)
    done
    if [ $KUBEDASH_UP -eq 0 ];then
      echo 'kube-dashboard never came up!' >> /root/kubesetup/log
      exit 1
    fi
    echo 'Kubernetes successfully set up.' >> /root/kubesetup/log
    EOH
  end

  directory '/root/.kube' do
    owner 'root'
    group 'root'
    mode 00755
    action :create
  end

  bash 'copy kubeconfig' do
    user 'root'
    cwd '/tmp'
    code <<-EOH
    cp /etc/kubernetes/admin.conf /root/.kube/.kubeconfig
    chmod 0600 /root/.kube/.kubeconfig
    EOH
    not_if '[ -f /root/.kube/.kubeconfig ]'
  end

  cookbook_file '/usr/local/bin/create-user-cert.sh' do
    owner 'root'
    group 'root'
    mode 00755
  end

  %w(nfs-kernel-server).each do |pkg|
    package pkg
  end

end
