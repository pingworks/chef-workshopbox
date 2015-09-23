#
# Cookbook Name:: wsbox_base
# Recipe:: _install_vbox_guest_additions
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

# a handy tool to detect the running vbox version
cookbook_file 'detect_vboxversion' do
  path '/usr/local/bin/detect_vboxversion'
  mode 0755
end

cookbook_file