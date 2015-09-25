#
# Cookbook Name:: wsbox-base
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

include_recipe 'wsbox-base::_mock_secrets'
include_recipe 'wsbox-base::_setup_local_secrets_repo'

include_recipe 'wsbox-base::_setup_user'

include_recipe 'wsbox-base::_install_docker'
include_recipe 'wsbox-base::_install_chefdk'

include_recipe 'wsbox-base::_install_firefox'
include_recipe 'wsbox-base::_install_atom'
