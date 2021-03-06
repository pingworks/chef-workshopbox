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
default['workshopbox']['domain'] = 'ws.p7-s.net'

default['workshopbox']['adminuser']['username'] = 'vagrant'
default['workshopbox']['adminuser']['home'] = '/home/vagrant'

default['workshopbox']['base_pkgs'] = %w(git vim less htop ncdu curl wget tree psmisc jq linux-headers-generic)
default['workshopbox']['preinstalled_gems'] = %w(kitchen-docker@2.3.0 mofa@0.3.40 rubocop@0.34.2)
default['workshopbox']['precloned_githubrepos'] = %w(phonebook-buildscripts phonebook-frontend phonebook-backend)
default['workshopbox']['precloned_githubcookbooks'] = %w()
default['workshopbox']['gitlab']['clone_url_tpl'] = 'ssh://git@gitlab.infra.svc.__DOMAIN__:10022/__USERNAME__/__PROJ__.git'

default['workshopbox']['wsboxinternal']['githubrepos'] = %w(chef-pw_testhelper chef-pw_base chef-ws_kitchen_docker_test chef-workshopbox chef-workshopbox_doc chef-secret_service)
default['workshopbox']['openstack_pkgs'] = %w(python-neutronclient python-novaclient python-openstackclient python-designateclient)

default['workshopbox']['atom_pkgs'] = %w(file-icons@2.1.3 language-chef@0.9.0 language-rspec@0.5.0 linter@1.11.18 linter-rubocop@0.5.0 linter-ruby@1.2.2 rspec-snippets@0.4.0 rubocop-auto-correct@1.5.1 serverspec-snippets@0.1.1)

# needed for custom ohai plugins
default['ohai']['plugins']['workshopbox'] = 'plugins'

# ----- Local Kubernetes Setup
default['workshopbox']['kubernetes']['docker-engine']['version'] = '1.11.2-0~xenial'

default['workshopbox']['kubernetes']['kubeversion'] = '1.6.4'
default['workshopbox']['kubernetes']['svccidr'] = '10.96.0.0/12'
default['workshopbox']['kubernetes']['svcdomain'] = 'cluster.local'
default['workshopbox']['kubernetes']['clusterdns'] = '10.96.0.10'
default['workshopbox']['kubernetes']['apiserver'] = '10.96.0.1'
default['workshopbox']['kubernetes']['gitlab']['adminpass'] = 'admin123'

# ----

# speed up converge:
default['workshopbox']['tweak']['reinstall_guest_additions'] = false
default['workshopbox']['tweak']['install_docker'] = true # kubernetes_master needs docker
default['workshopbox']['tweak']['install_docker_aux'] = false
default['workshopbox']['tweak']['install_kubernetes_client'] = false # kubernetes client for central workshop kubernetes
default['workshopbox']['tweak']['install_gnome_desktop'] = true
default['workshopbox']['tweak']['install_atom_pkgs'] = true
default['workshopbox']['tweak']['install_kubernetes_master'] = true

# speed up testing
default['workshopbox']['tweak']['test_kitchen_docker'] = false
