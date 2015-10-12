#
# Cookbook Name:: workshopbox
# Recipe:: default
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

bash 'set_editor_vim_root' do
  code <<-EOF
  echo 'export EDITOR=vim' >> /root/.bashrc
  EOF
  not_if 'grep \'EDITOR=vim\' /root/.bashrc', 'user' => 'root'
end

cookbook_file '/root/.vimrc'
