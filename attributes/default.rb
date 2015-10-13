# User Setup Prerequisit:
# a secret_service client repo (just a simple folderstructure) exists at:
default['workshopbox']['secret_service']['client']['repo'] = '/var/lib/secret-service'
default['workshopbox']['secret_service']['client']['user'] = 'root'

# Various Download Locations (to be mirrored in secluded environments like Conference Hotels)
default['workshopbox']['mirror']['apt'] = 'de.archive.ubuntu.com'
# default['workshopbox']['mirror']['apt'] = 'apt-mirror-ubuntu1404.la.pingworks.net'

default['workshopbox']['mirror']['vbox'] = 'download.virtualbox.org'

default['workshopbox']['mirror']['chef'] = 'opscode-omnibus-packages.s3.amazonaws.com'
# default['workshopbox']['mirror']['chef'] = 'apt-mirror-ubuntu1404.la.pingworks.net'

# default['workshopbox']['download']['chefdk']['url'] = "http://#{node['workshopbox']['mirror']['chef']}/ubuntu/12.04/x86_64/chefdk_0.7.0-1_amd64.deb"
default['workshopbox']['download']['chefdk']['sha256'] = '58b2e95768427f479b2114e02c924af1c51ed6b98fce829b439cc90692c3ca64'
default['workshopbox']['download']['chefdk']['url'] = "https://#{node['workshopbox']['mirror']['chef']}/ubuntu/12.04/x86_64/chefdk_0.7.0-1_amd64.deb"

default['workshopbox']['kitchen-docker']['baseimg'] = 'pingworks/docker-ws-baseimg:0.2'
default['workshopbox']['kitchen-docker']['testcookbook']['name'] = 'chef-ws-base'
default['workshopbox']['kitchen-docker']['testcookbook']['url'] = 'https://github.com/pingworks/chef-ws-base.git'
# default['workshopbox']['kitchen-docker']['testcookbook'] = 'git@github.com:pingworks/chef-ws-kitchen-docker-test.git'

# default['workshopbox']['domain'] = 'la.pingworks.net'
default['workshopbox']['domain'] = 'ws.pingworks.net'
default['workshopbox']['cname'] = 'workshopbox'

default['workshopbox']['adminuser']['username'] = 'vagrant'
default['workshopbox']['adminuser']['home'] = '/home/vagrant'

default['workshopbox']['preinstalled_gems'] = %w(kitchen-docker mofa)
default['workshopbox']['precloned_cookbooks'] = %w(phonebook chef-ws-phonebook-backend chef-workshopbox chef-secret_service chef-ws-testhelper chef-ws-base chef-ws-jenkins chef-ws-phonebook chef-devstack chef-ws-git-repo)
default['workshopbox']['openstack_pkgs'] = %w(python-neutronclient python-novaclient python-openstackclient python-designateclient)

default['ohai']['plugins']['workshopbox'] = 'plugins'
