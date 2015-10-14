#
# Cookbook Name:: workshopbox
# Recipe:: gnome_desktop
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

# see http://askubuntu.com/questions/685041/ubuntu-14-04-lts-gnome-core-installation-issue
# fix for broken ubuntu-desktop dependencies (1):
%w(libpython3.4-stdlib=3.4.0-2ubuntu1.1 libpython3.4-minimal=3.4.0-2ubuntu1.1).each do |pkg|
  package pkg
end

%w(ubuntu-desktop gnome-session-flashback gnome-terminal gnome-applets gnome-applets-data indicator-applet indicator-application indicator-appmenu indicator-messages indicator-session indicator-keyboard overlay-scrollbar overlay-scrollbar-gtk3 overlay-scrollbar-gtk2 notify-osd-icons ubuntu-docs ubuntu-system-service update-inetd xfonts-scalable mousetweaks sessioninstaller signond signon-ui signon-plugin-password ssl-cert signon-plugin-oauth2 signon-keyring-extension).each do |pkg|
  package pkg
end

# fix for broken ubuntu-desktop dependencies (2):
%w(lsb-release python3 update-notifier-common).each do |pkg|
  package pkg
end

# fix for broken ubuntu-desktop dependencies (3):
%w(libpython3.4-stdlib libpython3.4-minimal).each do |pkg|
  bash 'apt mark auto ' + pkg do
    code <<-EOC
      apt-mark auto #{pkg}
    EOC
  end
end

cookbook_file '/etc/lightdm/lightdm.conf'
