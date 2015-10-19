#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

include_recipe 'workshopbox::_setup_central_local_gitrepos'
include_recipe 'workshopbox::_setup_users'
include_recipe 'workshopbox::_install_chefdk'

include_recipe 'workshopbox::_install_firefox'
include_recipe 'workshopbox::_install_atom'
