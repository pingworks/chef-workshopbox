require_relative '../spec_helper'

describe package('docker-engine') do
  it { should be_installed }
end

describe command('docker --version') do
  its(:stdout) { should match /^Docker version 1.8.1, / }
end

describe service('docker') do
  it { should be_running }
  it { should be_enabled }
end

describe file('/etc/default/docker') do
  it { should be_file }
  its(:content) { should match /DOCKER_OPTS="-G adm"/ }
end

describe command('grep "^[^# ]" /etc/default/docker | wc -l') do
  its(:stdout) { should match /^1$/ }
end

Dir.foreach($node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
  next if username == '.' || username == '..' || $node['workshopbox']['secret_service']['client']['ignore_users'].include?(username)

  describe command("sudo su - #{username} -c 'docker images'") do
    its(:stdout) { should match /\s61f5cf76a264\s/ }
  end
end
