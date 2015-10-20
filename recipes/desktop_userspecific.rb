#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

include_recipe 'workshopbox::_setup_users_account'

include_recipe 'workshopbox::_setup_users_git'
include_recipe 'workshopbox::_setup_users_cheftooling'

include_recipe 'workshopbox::_setup_users_wsbox_internals'
include_recipe 'workshopbox::_setup_users_workspace'

# include_recipe 'workshopbox::_setup_users_atom'
# include_recipe 'workshopbox::_setup_users_firefox'

# 2b refactored
include_recipe 'workshopbox::_install_chefdk'

include_recipe 'workshopbox::_install_firefox'
include_recipe 'workshopbox::_install_atom'
