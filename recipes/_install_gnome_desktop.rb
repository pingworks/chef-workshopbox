#
# Cookbook Name:: ws-workshopbox
# Recipe:: gnome_desktop
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

#%w(xorg xterm gdm menu gksu synaptic gnome-session-flashback gnome-panel metacity gnome-terminal).each do |pkg|
#  package pkg
#end

%w(ubuntu-desktop gnome-session-flashback gnome-terminal gnome-applets gnome-applets-data indicator-applet indicator-application indicator-appmenu indicator-messages indicator-session indicator-keyboard overlay-scrollbar overlay-scrollbar-gtk3 overlay-scrollbar-gtk2 notify-osd-icons ubuntu-docs ubuntu-system-service update-inetd xfonts-scalable mousetweaks sessioninstaller signond signon-ui signon-plugin-password ssl-cert signon-plugin-oauth2 signon-keyring-extension).each do |pkg|
  package pkg
end

cookbook_file '/etc/lightdm/lightdm.conf'
