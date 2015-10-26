require_relative '../spec_helper'

describe command('chef --version') do
  its(:stdout) { should match /^Chef Development Kit Version: 0.7.0$/ }
  its(:stdout) { should match /^berks version: 3.2.4$/ }
end

describe command('rubocop --version') do
  its(:stdout) { should match /^0.34.2$/ }
end

describe command('mofa version') do
  its(:stdout) { should match /^0.2.17$/ }
end
