require_relative '../spec_helper'

$node['workshopbox']['base_pkgs'].each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end
