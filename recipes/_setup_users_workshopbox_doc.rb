#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_cheftooling
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

directory '/var/cache/workshopbox_doc' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

bash 'download workshopbox doc' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  set -e
  cd /var/cache/workshopbox_doc
  WORKSHOP_NAME=$(</etc/workshopbox/workshop_name)
  WORKSHOP_DOMAINKEY=$(</etc/workshopbox/workshop_domainkey)
  # WORKSHOP_DOMAINKEY=difficulttoguessdirname
  curl -k -O "https://download.pingworks.net/workshops/${WORKSHOP_NAME}/${WORKSHOP_DOMAINKEY}/workshopbox_doc.tar.gz"
  EOH
end

bash 'unpack and overwrite workshopbox_doc stuff' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
    set -e
    [ -d /tmp/workshopbox_doc ] && rm -rf /tmp/workshopbox_doc
    mkdir /tmp/workshopbox_doc
    cd /tmp/workshopbox_doc
    tar xvfz /var/cache/workshopbox_doc/workshopbox_doc.tar.gz
    rsync -avx --delete html/ /usr/share/nginx/html/
    chown -R www-data.www-data /usr/share/nginx/html/
  EOH
end
