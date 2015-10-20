#
# Cookbook Name:: workshopbox
# Recipe:: default
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

# make sure that no installation key is still active
cookbook_file '/tmp/id_rsa'

include_recipe 'workshopbox::_set_status_build_in_progress'

include_recipe 'ohai'

include_recipe 'workshopbox::hostsfile'

include_recipe 'workshopbox::sources_list'

include_recipe 'workshopbox::_setup_root'
include_recipe 'workshopbox::_install_base_packages'

include_recipe 'workshopbox::_install_docker'

include_recipe 'workshopbox::desktop_base'
include_recipe 'workshopbox::desktop_central_tools'
include_recipe 'workshopbox::desktop_userspecific'

include_recipe 'workshopbox::workshopbox_tools'

include_recipe 'workshopbox::_set_status_build_success'
