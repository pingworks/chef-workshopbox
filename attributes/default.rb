# Dry run (for faster roundtrips while build infrastruture testing)
default['ws-workshopbox']['dryrun'] = false

# User Setup Prerequisit:
# a secret-service client repo (just a simple folderstructure) exists at:
default['secret-service']['client']['repo'] = '/var/lib/secret-service'
default['secret-service']['client']['user'] = 'root'

# Various Download Locations (to be mirrored in secluded environments like Conference Hotels)
default['ws-workshopbox']['mirror']['apt'] = 'de.archive.ubuntu.com'
# default['ws-workshopbox']['mirror']['apt'] = 'apt-mirror-ubuntu1404.la.pingworks.net'

default['ws-workshopbox']['mirror']['vbox'] = 'download.virtualbox.org'

default['ws-workshopbox']['mirror']['chef'] = 'opscode-omnibus-packages.s3.amazonaws.com'
# default['ws-workshopbox']['mirror']['chef'] = 'apt-mirror-ubuntu1404.la.pingworks.net'

# default['ws-workshopbox']['download']['chefdk']['url'] = "http://#{node['ws-workshopbox']['mirror']['chef']}/ubuntu/12.04/x86_64/chefdk_0.7.0-1_amd64.deb"
default['ws-workshopbox']['download']['chefdk']['sha256'] = '58b2e95768427f479b2114e02c924af1c51ed6b98fce829b439cc90692c3ca64'
default['ws-workshopbox']['download']['chefdk']['url'] = "https://#{node['ws-workshopbox']['mirror']['chef']}/ubuntu/12.04/x86_64/chefdk_0.7.0-1_amd64.deb"

default['ws-workshopbox']['kitchen-docker']['baseimg'] = 'pingworks/docker-ws-baseimg:0.2'
default['ws-workshopbox']['kitchen-docker']['testcookbook']['name'] = 'chef-ws-base'
default['ws-workshopbox']['kitchen-docker']['testcookbook']['url'] = 'https://github.com/pingworks/chef-ws-base.git'
# default['ws-workshopbox']['kitchen-docker']['testcookbook'] = 'git@github.com:pingworks/chef-ws-kitchen-docker-test.git'

# default['ws-workshopbox']['domain'] = 'la.pingworks.net'
default['ws-workshopbox']['domain'] = 'ws.pingworks.net'
default['ws-workshopbox']['cname'] = 'workshopbox'

default['ws-workshopbox']['adminuser']['username'] = 'vagrant'
default['ws-workshopbox']['adminuser']['home'] = '/home/vagrant'

default['ws-workshopbox']['preinstalled_gems'] = %w(kitchen-docker mofa)
default['ws-workshopbox']['precloned_cookbooks'] = %w(phonebook chef-ws-phonebook-backend chef-ws-workshopbox chef-secret-service chef-ws-testhelper chef-ws-base chef-ws-jenkins chef-ws-phonebook chef-devstack chef-ws-git-repo)
default['ws-workshopbox']['openstack_pkgs'] = %w(python-neutronclient python-novaclient python-openstackclient python-designateclient)

default['ohai']['plugins']['ws-workshopbox'] = 'plugins'
