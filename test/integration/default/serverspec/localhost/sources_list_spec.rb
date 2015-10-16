require_relative '../spec_helper'

describe file('/etc/apt/sources.list') do
  its(:content) { should match /deb http:\/\/archive.ubuntu.com\/ubuntu trusty main restricted universe multiverse/ }
  its(:content) { should match /deb http:\/\/archive.ubuntu.com\/ubuntu trusty-updates main restricted universe multiverse/ }
  its(:content) { should match /deb http:\/\/archive.ubuntu.com\/ubuntu trusty-security main restricted universe multiverse/ }
end

describe file('/etc/apt/apt.conf.d/11auto') do
  it { should exist }
  its(:content) { should match /APT::Get::AllowUnauthenticated true;/ }
  its(:content) { should match /APT::Install-Recommends false;/ }
  its(:content) { should match /APT::Get::AutomaticRemove true;/ }
  its(:content) { should match /DPkg::Options {"--force-confold";};/ }
end
