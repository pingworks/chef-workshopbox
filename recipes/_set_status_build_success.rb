#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

bash 'set oldversion' do
  code <<-EOC
  if [ -f /etc/workshopbox/version ];then
    cp /etc/workshopbox/version /var/run/workshopbox/oldversion
  else
    echo 'none' > /var/run/workshopbox/oldversion
  fi
  EOC
end

template '/etc/workshopbox/version' do
  variables({
    :version => run_context.cookbook_collection['workshopbox'].metadata.version
  })
end

template '/var/run/workshopbox/status' do
  variables({
    :status => 'ready'
  })
end
