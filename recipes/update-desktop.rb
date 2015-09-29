#
# Cookbook Name:: ws-workshopbox
# Recipe:: default
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

# make sure that no installation key is still active
cookbook_file '/tmp/id_rsa'

include_recipe 'ohai'

include_recipe 'ws-workshopbox::desktop_personalized'
include_recipe 'ws-workshopbox::workshopbox_tools'
