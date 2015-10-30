require_relative '../spec_helper'

if $node['workshopbox']['tweak']['test_kitchen_docker'] == true
  describe command("sudo su - testuser -c 'cd /home/testuser/.wsbox/cookbooks/chef-ws_kitchen_docker_test;kitchen test'") do
    its(:stdout) { should match /1 example, 0 failures/ }
    its(:stdout) { should match /Finished destroying <default-ubuntu-1404>/ }
    its(:stdout) { should match /Finished testing <default-ubuntu-1404>/ }
  end
end

Dir.foreach($node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
  next if username == '.' || username == '..' || $node['workshopbox']['secret_service']['client']['ignore_users'].include?(username)



end
