#
# Cookbook Name:: ws-workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

include_recipe 'ws-workshopbox::_mock_secrets'
include_recipe 'ws-workshopbox::_setup_local_secrets_repo'

include_recipe 'ws-workshopbox::_setup_user'

include_recipe 'ws-workshopbox::_install_docker'
include_recipe 'ws-workshopbox::_install_chefdk'

include_recipe 'ws-workshopbox::_install_firefox'
include_recipe 'ws-workshopbox::_install_atom'
