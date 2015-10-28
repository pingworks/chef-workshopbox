require_relative '../spec_helper'

username = 'testuser'

describe command("sudo su - #{username} -c 'mofa version'") do
  its(:stdout) { should match /^0.3.2$/ }
end

describe command("sudo su - #{username} -c 'berks --version'") do
  its(:stdout) { should match /^3.2.4$/ }
end

describe command("sudo su - #{username} -c 'rubocop --version'") do
  its(:stdout) { should match /^0.34.2$/ }
end

describe command("sudo su - #{username} -c 'kitchen --version'") do
  its(:stdout) { should match /^Test Kitchen version 1.4.2$/ }
end
