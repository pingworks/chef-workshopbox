#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

package 'python-pip'

bash 'install urubu' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  pip install urubu
  EOH
end
