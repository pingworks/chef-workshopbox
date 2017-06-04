require_relative '../spec_helper'

# rubocop: disable GlobalVars
if $node['workshopbox']['tweak']['install_docker'] == true
  # rubocop: enable GlobalVars
  describe package('docker-engine') do
    it { should be_installed }
  end

  describe command('docker --version') do
    its(:stdout) { should match '^Docker version 1.11.2, ' }
  end

  describe service('docker') do
    it { should be_running }
    it { should be_enabled }
  end

  describe file('/etc/default/docker') do
    it { should be_file }
    its(:content) { should match 'DOCKER_OPTS="-G adm"' }
  end

  describe command('grep "^[^# ]" /etc/default/docker | wc -l') do
    its(:stdout) { should match '^1$' }
  end
  # rubocop: disable GlobalVars
  Dir.foreach($node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
    # rubocop: enable GlobalVars
    next if username == '.' || username == '..'

    describe command("sudo su - #{username} -c 'docker images'") do
      its(:stdout) { should match '\e7db2aa82996\s' }
    end
  end
end
