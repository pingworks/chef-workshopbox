# Always get secrets from remote server
#default['wsbox_base']['secret']['server'] = 'birk2.pingworks.net'
#default['wsbox_base']['secret']['user'] = 'secret'
#default['wsbox_base']['secret']['user_key'] = "/root/secret/#{node['wsbox_base']['secret']['user']}/id_rsa"
#default['wsbox_base']['secret']['basedir'] = '/var/lib/secret-server'
default['wsbox_base']['secret']['server'] = 'localhost'
default['wsbox_base']['secret']['user'] = 'vagrant'
default['wsbox_base']['secret']['user_key'] = "/home/vagrant/.ssh/id_rsa"
default['wsbox_base']['secret']['repo'] = '/home/vagrant/secret'

# The User that will use this personalized box
default['wsbox_base']['user']['username'] = 'testuser4'
default['wsbox_base']['user']['home'] = "/home/#{node['wsbox_base']['user']['username']}"
default['wsbox_base']['user']['secret']['id_rsa'] = "#{node['wsbox_base']['secret']['user']}@#{node['wsbox_base']['secret']['server']}:#{node['wsbox_base']['secret']['repo']}/user/#{node['wsbox_base']['user']['username']}/id_rsa"
default['wsbox_base']['user']['secret']['id_rsa.pub'] = "#{node['wsbox_base']['secret']['user']}@#{node['wsbox_base']['secret']['server']}:#{node['wsbox_base']['secret']['repo']}/user/#{node['wsbox_base']['user']['username']}/id_rsa.pub"
default['wsbox_base']['user']['secret']['password'] = "#{node['wsbox_base']['secret']['user']}@#{node['wsbox_base']['secret']['server']}:#{node['wsbox_base']['secret']['repo']}/user/#{node['wsbox_base']['user']['username']}/password"

default['wsbox_base']['mirror']['apt'] = 'apt-mirror-ubuntu1404.la.pingworks.net'
default['wsbox_base']['mirror']['vbox'] = 'download.virtualbox.org'

default['wsbox_base']['domain'] = 'la.pingworks.net'
default['wsbox_base']['cname'] = 'workshopbox'

default['wsbox_base']['adminuser']['username'] = 'vagrant'
default['wsbox_base']['adminuser']['home'] = '/home/vagrant'

default['ohai']['plugins']['wsbox_base'] = 'plugins'
