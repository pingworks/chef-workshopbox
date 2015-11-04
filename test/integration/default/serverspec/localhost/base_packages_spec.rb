require_relative '../spec_helper'

# rubocop: disable GlobalVars
$node['workshopbox']['base_pkgs'].each do |pkg|
  # rubocop: enable GlobalVars
  describe package(pkg) do
    it { should be_installed }
  end
end
