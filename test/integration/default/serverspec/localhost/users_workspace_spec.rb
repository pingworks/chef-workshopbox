require_relative '../spec_helper'

# rubocop: disable GlobalVars
if $node['workshopbox']['tweak']['test_kitchen_docker'] == true
  # rubocop: enable GlobalVars
  describe command("sudo su - testuser -c 'cd /home/testuser/.wsbox/cookbooks/chef-ws_kitchen_docker_test;kitchen test'") do
    its(:stdout) { should match '1 example, 0 failures' }
    its(:stdout) { should match 'Finished destroying <default-ubuntu-1404>' }
    its(:stdout) { should match 'Finished testing <default-ubuntu-1404>' }
  end
end
# rubocop: disable GlobalVars
Dir.foreach($node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
  # rubocop: enable GlobalVars
  next if username == '.' || username == '..'
end
