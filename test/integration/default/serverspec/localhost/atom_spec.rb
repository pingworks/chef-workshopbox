require_relative '../spec_helper'

# rubocop: disable GlobalVars
if $node['workshopbox']['tweak']['install_gnome_desktop'] == true
  # rubocop: enable GlobalVars
  describe command('dpkg -s atom') do
    its(:stdout) { should match '^Version: 1\.0\.19.*' }
  end

  # rubocop: disable GlobalVars
  Dir.foreach($node['workshopbox']['secret_service']['client']['repo'] + '/user') do |username|
    # rubocop: enable GlobalVars
    next if username == '.' || username == '..'

    describe file("/home/#{username}/.atom") do
      it { should be_directory }
      it { should be_owned_by username }
      it { should be_grouped_into username }
      it { should be_mode '755' }
    end

    describe file("/home/#{username}/.atom/.apmrc") do
      it { should exist }
      it { should be_file }
      it { should be_owned_by username }
      it { should be_grouped_into username }
      it { should be_mode '644' }
      its(:content) { should match '^strict-ssl = false$' }
    end

    describe command("su - #{username} -c \'apm list\' > /tmp/apm_list_#{username}") do
      its(:exit_status) { should eq 0 }
    end

    # rubocop: disable GlobalVars
    $node['workshopbox']['atom_pkgs'].each do |apkg|
      # rubocop: enable GlobalVars
      describe command("grep #{apkg} /tmp/apm_list_#{username}") do
        its(:stdout) { should match apkg.to_s }
        its(:exit_status) { should eq 0 }
      end
    end

    describe file("/home/#{username}/.atom/config.cson") do
      it { should exist }
      it { should be_file }
      it { should be_owned_by username }
      it { should be_grouped_into username }
      it { should be_mode '644' }
      its(:content) { should match %r{"linter-rubocop":\s*command: "/opt/chefdk/bin/rubocop"} }
      its(:content) { should match %r{"linter-ruby":\s*rubyExecutablePath: "/opt/chefdk/embedded/bin/ruby"} }
      its(:content) { should match %r{"linter-erb":\s*erbExecutablePath: "/opt/chefdk/bin/erb"} }
      its(:content) { should match %r{"rubocop-auto-correct":\s*autoRun: true\s*correctFile: true\s*rubocopCommandPath: "/opt/chefdk/bin/rubocop"} }
    end
  end
end
