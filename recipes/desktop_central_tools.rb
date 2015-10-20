#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

include_recipe 'workshopbox::_install_nginx'
include_recipe 'workshopbox::_install_urubu'

include_recipe 'workshopbox::_setup_central_local_gitrepos'
