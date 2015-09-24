#
# Cookbook Name:: wsbox_base
# Recipe:: personalize
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

include_recipe 'wsbox_base::_mock_secrets'

include_recipe 'wsbox_base::_setup_user'
include_recipe 'wsbox_base::_setup_user_secrets'
