#
# Cookbook Name:: wsbox-base
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

include_recipe 'wsbox-base::_install_gnome_desktop'
include_recipe 'wsbox-base::_reinstall_guest_additions'
