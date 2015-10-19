#
# Cookbook Name:: workshopbox
#
# Copyright (C) 2015 Alexander Birk
#
# Licensed under the Apache License, Version 2.0
#

%w(git vim less htop ncdu curl wget).each do |pkg|
  package pkg
end
