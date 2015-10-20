#
# Cookbook Name:: workshopbox
# Recipe:: xfce_desktop
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

# Basic Graphic Stack
# see https://xpressubuntu.wordpress.com/2014/02/22/how-to-install-a-minimal-ubuntu-desktop/
%w(xserver-xorg xserver-xorg-core xfonts-base xinit x11-xserver-utils).each do |pkg|
  package pkg
end

# xfce vm + utils
%w(xfwm4 xfce4-panel xfce4-settings xfce4-session xfce4-terminal xfdesktop4 xfce4-taskmanager tango-icon-theme).each do |pkg|
  package pkg
end

# graphical loginmanager
%w(lightdm lightdm-gtk-greeter).each do |pkg|
  package pkg
end

# cookbook_file '/etc/lightdm/lightdm.conf'
