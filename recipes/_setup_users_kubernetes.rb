#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_docker
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#
if node['workshopbox']['tweak']['install_kubernetes_client'] == true
  Dir.foreach(node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
    next if username == '.' || username == '..'
    directory "/home/#{username}/.kube" do
      owner username
      group username
      mode 00755
      action :create
    end

    bash 'copy user access certs' do
      user 'root'
      cwd '/tmp'
      code <<-EOH
      cp #{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}/#{username}-config.zip /home/#{username}/
      cd /home/#{username}
      unzip #{username}-config.zip
      chown -R #{username}.#{username} /home/#{username}/.kube
      chmod 600 /home/#{username}/.kube/config
      rm #{username}-config.zip
      EOH
    end
  end
end
if node['workshopbox']['tweak']['install_kubernetes_master'] == true
  Dir.foreach(node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
    next if username == '.' || username == '..'
    directory "/home/#{username}/.kube" do
      owner username
      group username
      mode 00755
      action :create
    end

    bash 'copy admin certs' do
      user 'root'
      cwd '/tmp'
      code <<-EOH
      cp /etc/kubernetes/admin.conf /home/#{username}/.kube/config
      chown -R #{username}.#{username} /home/#{username}/.kube
      chmod 600 /home/#{username}/.kube/config
      EOH
    end

    directory "/home/#{username}/.kubesetup" do
      owner username
      group username
      mode 00755
      action :create
    end

    template "/home/#{username}/.kubesetup/namespace.yaml" do
      owner username
      group username
      variables namespace: username
    end

    # Setup Users namespaces
    bash "setup user #{username} namespace" do
      user 'root'
      cwd '/tmp'
      environment 'HOME' => '/root'
      code <<-EOH
        kubectl create -f /home/#{username}/.kubesetup/namespace.yaml
      EOH
      not_if "kubectl get namespaces | grep '^#{username} '", environment: { 'HOME' => '/root' }
    end

    # Setup Users namespaces
    bash "setup users rolebinding #{username}" do
      user 'root'
      cwd '/tmp'
      environment 'HOME' => '/root'
      code <<-EOH
        kubectl create rolebinding sa-default-edit --clusterrole=edit --serviceaccount=#{username}:default --namespace=#{username}
      EOH
      not_if "kubectl get rolebindings --namespace=#{username} | grep '^sa-default-edit '", environment: { 'HOME' => '/root' }
    end

    # Setup gitlab users
    bash "setting up gitlab user #{username}" do
      user 'root'
      cwd '/tmp'
      environment 'HOME' => '/root'
      code <<-EOH
      UDIR=#{node['workshopbox']['secret_service']['client']['repo']}/user/#{username}
      NAME="$(<$UDIR/firstname) $(<$UDIR/lastname)"
      PASSWORD="#{username}"
      EMAIL=$(<$UDIR/email)
      COMPANY=$(<$UDIR/company)
      SSH_PUB=$(<$UDIR/.ssh/id_rsa.pub)
      env >> /tmp/debug.log

      cat <<-EOF > /home/#{username}/.kubesetup/user.json
      {
        "username": "$USERNAME",
        "email": "$EMAIL",
        "name": "$NAME",
        "password": "$PASSWORD",
        "organization": "$COMPANY"
      }
      EOF
      echo "hier" >> /tmp/debug.log
      GITLAB_ROOT_PW='admin123'
      GITLAB_URL='http://gitlab.infra.svc.cluster.local'

      echo "curl -s $GITLAB_URL/api/v3/session --data \"login=root&password=$GITLAB_ROOT_PW\"" >> /tmp/debug.log
      curl -s $GITLAB_URL/api/v3/session --data \"login=root&password=$GITLAB_ROOT_PW\" >> /tmp/debug.log

      GITLAB_PRIVATE_TOKEN=$(curl -s $GITLAB_URL/api/v3/session --data "login=root&password=$GITLAB_ROOT_PW" | jq  -r '.private_token')

      echo "############### Checking if user $USERNAME exists..." >> /tmp/debug.log
      if curl -XGET -s -H "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" $GITLAB_URL/api/v3/users?per_page=100 | jq -r ".[] | select(.username==\"#{username}\") | .username" | grep "^#{username}$" >> /tmp/debug.log; then
        echo "############### User already exists! Skipping..." >> /tmp/debug.log
      else
        echo "############### User does not exist. Provisioning user!" >> /tmp/debug.log

        echo "############### Creating user..." >> /tmp/debug.log
        curl -XPOST -H "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" -H "Content-Type: application/json" -d @/home/#{username}/.kubesetup/user.json $GITLAB_URL/api/v3/users >> /tmp/debug.log

        echo "############### Getting user id..." >> /tmp/debug.log
        USERID=$(curl --silent -XGET -H "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" $GITLAB_URL/api/v3/users?per_page=100 2>&1 | jq ".[] | select(.username==\"#{username}\") | .id")
        echo "############### \$USERID is: $USERID" >> /tmp/debug.log
        if [ -z $USERID ];then
          echo "ERROR: USERID not found. This probably means that the user wasnt created!"
          exit 1
        fi

        cat <<-EOG > /home/#{username}/.kubesetup/ssh.json
        {
          "id": "$USERID",
          "title": "${USERNAME}-key",
          "key": "$SSH_PUB"
        }
        EOG

        echo "############### Adding ssh key..." >> /tmp/debug.log
        curl -XPOST --silent -H "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" -H "Content-Type: application/json" --data-binary @$UDIR/ssh.json $GITLAB_URL/api/v3/users/$USERID/keys  >> /tmp/debug.log
      fi

      EOH
    end
  end
end
