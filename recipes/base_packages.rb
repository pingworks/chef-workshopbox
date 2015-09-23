#
# Cookbook Name:: wsbox_base
# Recipe:: base_packages
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

%w(git vim less htop).each do |pkg|
  package pkg
end
