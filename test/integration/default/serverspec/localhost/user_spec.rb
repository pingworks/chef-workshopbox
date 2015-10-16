require_relative '../spec_helper'

describe file('/var/lib/secret-service') do
  it { should exist }
  it { should be_directory }
  it { should be_mode '755' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/var/lib/secret-service/user/testuser/.ssh') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '700' }
end

describe file('/var/lib/secret-service/user/testuser/.ssh/id_rsa') do
  it { should exist }
  it { should be_mode '600' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /MIIEowIBAAKCAQEAmSh6t/ }
end

describe file('/var/lib/secret-service/user/testuser/.ssh/id_rsa.pub') do
  it { should exist }
  it { should be_mode '600' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /LbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key/ }
end

describe file('/var/lib/secret-service/user/testuser/.ssh/authorized_keys') do
  it { should exist }
  it { should be_mode '600' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /AAAAB3NzaC1yc2EAAAADAQABAAABAQC1hh7uJkucMfFBf/ }
  its(:content) { should match /AAAAB3NzaC1yc2EAAAABIwAAAIEAyC6PPv3qndUgk/ }
end

describe file('/var/lib/secret-service/user/testuser/firstname') do
  it { should exist }
  it { should be_mode '644' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /^Theo$/ }
end

describe file('/var/lib/secret-service/user/testuser/lastname') do
  it { should exist }
  it { should be_mode '644' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /^Testuser$/ }
end

describe file('/var/lib/secret-service/user/testuser/email') do
  it { should exist }
  it { should be_mode '644' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /^theo.testuser@example.com$/ }
end

describe file('/var/lib/secret-service/user/testuser/password_sha512') do
  it { should be_mode '600' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /p0jQ8T1yYNLaucTc9ItIIcrQVF9O94ZDiiLNUBcvLUyZ139wrwzKz/ }
end

describe file('/var/lib/secret-service/user/testuser/password') do
  it { should_not exist }
end
