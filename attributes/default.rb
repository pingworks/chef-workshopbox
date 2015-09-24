# Always get secrets from remote server
#default['wsbox-base']['secret']['server'] = 'birk2.pingworks.net'
#default['wsbox-base']['secret']['user'] = 'secret'
#default['wsbox-base']['secret']['user_key'] = "/root/secret/#{node['wsbox-base']['secret']['user']}/id_rsa"
#default['wsbox-base']['secret']['basedir'] = '/var/lib/secret-server'
default['wsbox-base']['secret']['server'] = 'localhost'
default['wsbox-base']['secret']['user'] = 'vagrant'
default['wsbox-base']['secret']['user_key'] = "/home/vagrant/.ssh/id_rsa"
default['wsbox-base']['secret']['repo'] = '/home/vagrant/secret'

# The User that will use this personalized box
default['wsbox-base']['user']['username'] = 'testuser4'
default['wsbox-base']['user']['home'] = "/home/#{node['wsbox-base']['user']['username']}"
default['wsbox-base']['user']['secret']['id_rsa'] = "#{node['wsbox-base']['secret']['user']}@#{node['wsbox-base']['secret']['server']}:#{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}/id_rsa"
default['wsbox-base']['user']['secret']['id_rsa.pub'] = "#{node['wsbox-base']['secret']['user']}@#{node['wsbox-base']['secret']['server']}:#{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}/id_rsa.pub"
default['wsbox-base']['user']['secret']['password'] = "#{node['wsbox-base']['secret']['user']}@#{node['wsbox-base']['secret']['server']}:#{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}/password"

default['wsbox-base']['mirror']['apt'] = 'apt-mirror-ubuntu1404.la.pingworks.net'
default['wsbox-base']['mirror']['vbox'] = 'download.virtualbox.org'

default['wsbox-base']['domain'] = 'la.pingworks.net'
default['wsbox-base']['cname'] = 'workshopbox'

default['wsbox-base']['adminuser']['username'] = 'vagrant'
default['wsbox-base']['adminuser']['home'] = '/home/vagrant'

default['ohai']['plugins']['wsbox-base'] = 'plugins'
