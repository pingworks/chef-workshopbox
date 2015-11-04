require_relative '../spec_helper'

describe package('nginx') do
  it { should be_installed }
end

describe file('/usr/share/nginx/html') do
  it { should be_directory }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
  it { should be_mode '755' }
end

describe file('/etc/nginx/sites-enabled/default') do
  its(:content) { should match %r{location / .\s*autoindex on;} }
  its(:content) { should match %r{root /usr/share/nginx/html;} }
  its(:content) { should match 'server_name localhost;' }
  its(:content) { should match 'listen 80' }
end

describe port(80) do
  it { should be_listening.with('tcp') }
end

describe service('nginx') do
  it { should be_running }
  it { should be_enabled }
end
