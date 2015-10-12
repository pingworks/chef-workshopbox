#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

include_recipe 'workshopbox::_install_gnome_desktop'
include_recipe 'workshopbox::_reinstall_guest_additions'
