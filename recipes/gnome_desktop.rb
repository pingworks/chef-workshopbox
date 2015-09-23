#
# Cookbook Name:: wsbox_base
# Recipe:: gnome_desktop
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

#%w(xorg xterm gdm menu gksu synaptic gnome-session-flashback gnome-panel metacity gnome-terminal).each do |pkg|
#  package pkg
#end

%w(ubuntu-desktop gnome-session-flashback).each do |pkg|
  package pkg
end

template '/etc/lightdm/lightdm.conf'
