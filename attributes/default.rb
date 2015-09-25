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
default['wsbox-base']['user']['username'] = 'testuser3'
default['wsbox-base']['user']['email'] = 'testuser@ws.pingworks.net'
default['wsbox-base']['user']['fullname'] = 'Tim Testuser'
default['wsbox-base']['user']['home'] = "/home/#{node['wsbox-base']['user']['username']}"
default['wsbox-base']['user']['secret']['id_rsa'] = "#{node['wsbox-base']['secret']['user']}@#{node['wsbox-base']['secret']['server']}:#{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}/id_rsa"
default['wsbox-base']['user']['secret']['id_rsa.pub'] = "#{node['wsbox-base']['secret']['user']}@#{node['wsbox-base']['secret']['server']}:#{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}/id_rsa.pub"
default['wsbox-base']['user']['secret']['password'] = "#{node['wsbox-base']['secret']['user']}@#{node['wsbox-base']['secret']['server']}:#{node['wsbox-base']['secret']['repo']}/user/#{node['wsbox-base']['user']['username']}/password"

# Various Download Locations (to be mirrored in secluded environments like Conference Hotels)
default['wsbox-base']['mirror']['apt'] = 'apt-mirror-ubuntu1404.la.pingworks.net'
default['wsbox-base']['mirror']['vbox'] = 'download.virtualbox.org'
default['wsbox-base']['mirror']['chef'] = 'apt-mirror-ubuntu1404.la.pingworks.net'
#efault['wsbox-base']['mirror']['chef'] = 'opscode-omnibus-packages.s3.amazonaws.com'
#default['wsbox-base']['download']['chefdk']['url'] = "https://#{node['wsbox-base']['mirror']['chef']}/ubuntu/12.04/x86_64/chefdk_0.7.0-1_amd64.deb"
default['wsbox-base']['download']['chefdk']['url'] = "http://#{node['wsbox-base']['mirror']['chef']}/ubuntu/12.04/x86_64/chefdk_0.7.0-1_amd64.deb"
default['wsbox-base']['download']['chefdk']['sha256'] = '58b2e95768427f479b2114e02c924af1c51ed6b98fce829b439cc90692c3ca64'

default['wsbox-base']['domain'] = 'la.pingworks.net'
default['wsbox-base']['cname'] = 'workshopbox'

default['wsbox-base']['adminuser']['username'] = 'vagrant'
default['wsbox-base']['adminuser']['home'] = '/home/vagrant'

default['ohai']['plugins']['wsbox-base'] = 'plugins'
