require_relative '../spec_helper'

%w(git vim less ncdu htop wget curl).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end
