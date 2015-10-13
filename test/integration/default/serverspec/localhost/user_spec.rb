require_relative '../spec_helper'

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe file('/var/lib/secret-service') do
  it { should exist }
  it { should be_directory }
  it { should be_mode '700' }
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
