#
# Cookbook Name:: workshopbox
# Recipe:: _setup_users_cheftooling
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

Dir.foreach(node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
  next if username == '.' || username == '..' || node['workshopbox']['secret_service']['client']['ignore_users'].include?(username)

  %w(.dmrc .xinputrc).each do |f|
    cookbook_file "/home/#{username}/#{f}" do
      owner username
      group username
      mode 00644
    end
  end

  %w(.config .gconf .local).each do |d|
    directory "/home/#{username}/#{d}" do
      owner username
      group username
      mode 00755
    end
  end

  %w(dconf gnome-session gtk-3.0 update-notifier upstart).each do |d|
    directory "/home/#{username}/.config/#{d}" do
      owner username
      group username
      mode 00755
    end
  end

  %w(user-dirs.dirs user-dirs.locale).each do |f|
    cookbook_file "/home/#{username}/.config/#{f}" do
      owner username
      group username
      mode 00644
    end
  end

  cookbook_file "/home/#{username}/.config/dconf/user" do
    owner username
    group username
    mode 00644
  end

  template "/home/#{username}/.config/gtk-3.0/bookmarks" do
    owner username
    group username
    mode 00644
    variables(
      username: username
    )
  end
end
