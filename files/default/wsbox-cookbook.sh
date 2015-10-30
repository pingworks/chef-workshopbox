#!/bin/bash

# wrapper for berks cookbook
#!/bin/bash

cookbook=$1
dir=$2
pattern=$3

if [ -z "$dir" ]; then
  dir="chef-$cookbook"
fi
opts=""
if [ ! -z "$pattern" ]; then
  opts="-p $pattern"
fi

if [ -d /var/lib/secret-service/user/$USER ]; then
  NAME="$(</var/lib/secret-service/user/$USER/firstname) $(</var/lib/secret-service/user/$USER/lastname)"
  EMAIL="$(</var/lib/secret-service/user/$USER/email)"
else
  NAME="$USER"
  EMAIL="info@pingworks.de"
fi

[ -f $dir/metadata.rb ] || berks cookbook \
	--skip-vagrant \
	--no-skip-git \
	--skip-test-kitchen \
	--no-foodcritic \
	--no-chef-minitest \
	--no-scmversion \
	--no-bundler \
	--license=apachev2 \
	--maintainer="$NAME" \
	--maintainer-email="$EMAIL" \
	$opts $cookbook $dir

for sub in libraries resources providers; do
  [ -d $dir/$sub ] && [ -z "$(find $dir/$sub -type f)" ] && rmdir $dir/$sub
done

app=${1#pw_}

mkdir -p $dir/test/integration/default/serverspec/localhost
cat << EOF > $dir/test/integration/default/serverspec/localhost/default_spec.rb
require_relative '../spec_helper'

describe command('echo "foo"') do
  its(:stdout) { should match /^foo/ }
end
EOF

cat << EOF > $dir/test/integration/default/serverspec/spec_helper.rb
require 'serverspec'
require 'json'
require 'net/ssh'

set :backend, :exec

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    warn "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)

options[:user] ||= ENV['RSPEC_USER']
options[:user] ||= 'Etc.getlogin'

set :host,        options[:host_name] || host
set :ssh_options, options

nodejson = '/tmp/serverspec-test/node.json'
if File.exists? nodejson then
  \$node = ::JSON.parse(File.read(nodejson))
else
  warn "Node json not readable: " + nodejson
end


# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:\$PATH'
EOF

grep '.kitchen' $dir/.gitignore >/dev/null || cat << EOF >> $dir/.gitignore
.kitchen/
.kitchen.local.yml

EOF

grep '.mofa' $dir/.gitignore >/dev/null || cat << EOF >> $dir/.gitignore
.mofa/
.mofa.local.yml

EOF

[ -f $dir/.kitchen.yml ] || cat << EOF > $dir/.kitchen.yml
---
driver:
  name: docker

provisioner:
  name: chef_solo

platforms:
  - name: ubuntu-14.04
    driver_config:
      image: pingworks/docker-ws-baseimg:0.2

suites:
  - name: default
    run_list:
    - recipe[$cookbook::default]
    attributes:
EOF

sed -i -e "s;TODO: Enter the cookbook description here.;Installs and configures $app;" \
	-e "s;TODO: List your supported platforms.;Ubuntu 14.04;" $dir/README.md

sed -i -e "s;Installs/Configures $cookbook;Installs and configures $app;" $dir/metadata.rb

echo "Done."
echo
echo "Please find your fresh & empty cookbook here:"
echo "cd ./chef-$1"
echo
echo "kitchen create (to create a new empty test vm)"
echo "kitchen converge (to apply your recipes to the test vm)"
echo "kitchen verify (to run the infrastructure tests)"
echo "kitchen destroy (to throw awqay the test vm)"
echo "kitchen login (to log into the test vm)"
