#
# Cookbook Name:: ws-workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

template '/var/run/workshopbox/status' do
  variables({
    :status => 'build_in_progress:' + run_context.cookbook_collection['ws-workshopbox'].metadata.version
  })
end
