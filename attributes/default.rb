# User Setup Prerequisit:
# a secret_service client repo (just a simple folderstructure) exists at:
default['workshopbox']['secret_service']['client']['repo'] = '/var/lib/secret-service'
default['workshopbox']['secret_service']['client']['user'] = 'root'

# choose flavor (only gnome supported yet)
default['workshopbox']['desktop'] = 'gnome'

# Various Download Locations (to be mirrored in secluded environments like Conference Hotels)
default['workshopbox']['mirror']['apt'] = 'archive.ubuntu.com'
default['workshopbox']['mirror']['vbox'] = 'download.virtualbox.org'

default['workshopbox']['download']['chefdk']['sha256'] = '58b2e95768427f479b2114e02c924af1c51ed6b98fce829b439cc90692c3ca64'
default['workshopbox']['download']['chefdk']['url'] = 'http://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.7.0-1_amd64.deb'

default['workshopbox']['kitchen-docker']['baseimg'] = 'pingworks/docker-ws-baseimg:0.2'

default['workshopbox']['cname'] = 'workshopbox'
default['workshopbox']['domain'] = 'ws.net'

default['workshopbox']['adminuser']['username'] = 'vagrant'
default['workshopbox']['adminuser']['home'] = '/home/vagrant'

default['workshopbox']['preinstalled_gems'] = %w(kitchen-docker mofa)
default['workshopbox']['precloned_githubrepos'] = %w(phonebook chef-workshopbox chef-workshopbox_doc chef-secret_service chef-pw_testhelper chef-pw_base chef-pw_jenkins chef-ws-phonebook chef-ws-env-phonebook chef-ws-env-pipeline)
default['workshopbox']['openstack_pkgs'] = %w(python-neutronclient python-novaclient python-openstackclient python-designateclient)

default['workshopbox']['atom_pkgs'] = %w(file-icons@1.6.11 language-chef@0.7.0 language-rspec@0.3.0 linter@1.8.1 linter-rubocop@0.4.4 linter-ruby@1.2.0 rspec-snippets@0.4.0 rubocop-auto-correct@1.0.0 serverspec-snippets@0.1.0)

# needed for custom ohai plugins
default['ohai']['plugins']['workshopbox'] = 'plugins'

default['workshopbox']['wsboxinternal']['githubrepos'] = %w(chef-workshopbox chef-workshopbox_doc chef-secret_service chef-pw_testhelper)
