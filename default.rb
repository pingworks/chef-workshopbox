# Always get secrets from remote server
#default['ws-workshopbox']['secret']['server'] = 'birk2.pingworks.net'
#default['ws-workshopbox']['secret']['user'] = 'secret'
#default['ws-workshopbox']['secret']['user_key'] = "/root/secret/#{node['ws-workshopbox']['secret']['user']}/id_rsa"
#default['ws-workshopbox']['secret']['basedir'] = '/var/lib/secret-server'
default['ws-workshopbox']['secret']['server'] = 'localhost'
default['ws-workshopbox']['secret']['user'] = 'vagrant'
default['ws-workshopbox']['secret']['user_key'] = "/home/vagrant/.ssh/id_rsa"
default['ws-workshopbox']['secret']['repo'] = '/home/vagrant/secret'

# Various Download Locations (to be mirrored in secluded environments like Conference Hotels)
#default['ws-workshopbox']['mirror']['apt'] = 'de.archive.ubuntu.com'
default['ws-workshopbox']['mirror']['apt'] = 'apt-mirror-ubuntu1404.la.pingworks.net'
default['ws-workshopbox']['mirror']['vbox'] = 'download.virtualbox.org'
#default['ws-workshopbox']['mirror']['chef'] = 'apt-mirror-ubuntu1404.la.pingworks.net'
#default['ws-workshopbox']['mirror']['chef'] = 'opscode-omnibus-packages.s3.amazonaws.com'
default['ws-workshopbox']['download']['chefdk']['url'] = "https://#{node['ws-workshopbox']['mirror']['chef']}/ubuntu/12.04/x86_64/chefdk_0.7.0-1_amd64.deb"
default['ws-workshopbox']['download']['chefdk']['url'] = "http://#{node['ws-workshopbox']['mirror']['chef']}/ubuntu/12.04/x86_64/chefdk_0.7.0-1_amd64.deb"
default['ws-workshopbox']['download']['chefdk']['sha256'] = '58b2e95768427f479b2114e02c924af1c51ed6b98fce829b439cc90692c3ca64'
default['ws-workshopbox']['kitchen-docker']['baseimg'] = 'pingworks/docker-ws-baseimg:0.2'
default['ws-workshopbox']['kitchen-docker']['testcookbook'] = 'https://github.com/pingworks/chef-ws-kitchen-docker-test.git'
#default['ws-workshopbox']['kitchen-docker']['testcookbook'] = 'git@github.com:pingworks/chef-ws-kitchen-docker-test.git'

#default['ws-workshopbox']['domain'] = 'la.pingworks.net'
default['ws-workshopbox']['domain'] = 'ws.pingworks.net'
default['ws-workshopbox']['cname'] = 'workshopbox'

default['ws-workshopbox']['adminuser']['username'] = 'vagrant'
default['ws-workshopbox']['adminuser']['home'] = '/home/vagrant'

default['ohai']['plugins']['ws-workshopbox'] = 'plugins'
