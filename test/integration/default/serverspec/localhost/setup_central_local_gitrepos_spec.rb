require_relative '../spec_helper'

describe file('/var/lib/workshopbox/github') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '755' }
end

githubrepos = $node['workshopbox']['wsboxinternal']['githubrepos'] | $node['workshopbox']['precloned_githubrepos']

githubrepos.each do |repo|
  describe file("/var/lib/workshopbox/github/#{repo}") do
    it { should exist }
    it { should be_directory }
    it { should be_mode '755' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file("/var/lib/workshopbox/github/#{repo}/.git") do
    it { should exist }
    it { should be_directory }
    it { should be_mode '755' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
