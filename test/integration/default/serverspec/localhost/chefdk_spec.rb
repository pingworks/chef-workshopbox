require_relative '../spec_helper'

# rubocop: disable GlobalVars
if $node['workshopbox']['tweak']['install_chefdk'] == true
  # rubocop: enable GlobalVars
  describe command("sudo su - testuser -c 'mofa version'") do
    its(:stdout) { should match '^0.3.5$' }
  end

  describe command("sudo su - testuser -c 'berks --version'") do
    its(:stdout) { should match '^3.2.4$' }
  end

  describe command("sudo su - testuser -c 'rubocop --version'") do
    its(:stdout) { should match '^0.34.2$' }
  end

  describe command("sudo su - testuser -c 'kitchen --version'") do
    its(:stdout) { should match '^Test Kitchen version 1.4.2$' }
  end

  describe file('/home/testuser/.wsbox/cookbooks/chef-pw_base/files/default/id_rsa') do
    it { should exist }
  end

  describe file('/home/testuser/.mofa/config.yml') do
    it { should be_file }
    it { should be_owned_by 'testuser' }
    it { should be_grouped_into 'testuser' }
    its(:content) { should match '^ssh_user: testuser' }
    # rubocop: disable GlobalVars
    its(:content) { should match "^binrepo_base_url: 'http://repo.testuser.#{$node['workshopbox']['domain']}/cookbooks'" }
    its(:content) { should match "^binrepo_host: repo.testuser.#{$node['workshopbox']['domain']}" }
    # rubocop: enable GlobalVars
    its(:content) { should match '^binrepo_ssh_user: jenkins' }
    its(:content) { should match '^binrepo_ssh_port: 22' }
    its(:content) { should match '^binrepo_ssh_keyfile: /home/testuser/.wsbox/cookbooks/chef-pw_base/files/default/id_rsa' }
    its(:content) { should match '^binrepo_import_dir: /data/cookbooks/import' }
  end
end
