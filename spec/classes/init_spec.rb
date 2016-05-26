require 'spec_helper'

describe 'pe_winagent', :type => :class do

  let(:public_dir) { '/opt/puppet/mock' }

  context 'Puppet Enterprise 3.3.x' do
    let(:facts) do
      {
        :pe_build => "3.3.0"
      }
    end
    let(:params) do
      {
        :puppetserver => 'puppetmaster.local',
        :caserver     => 'caserver.local',
      }
    end
    it 'with defaults' do
      is_expected.to contain_file('/opt/puppet/mock/3.3.0/windows')
      is_expected.to contain_pe_staging__file('puppet-enterprise-3.3.0.msi').with({ 
      :source => 'https://s3.amazonaws.com/pe-builds/released/3.3.0/puppet-enterprise-3.3.0.msi',
      :target => '/opt/puppet/mock/3.3.0/windows/puppet-enterprise-3.3.0.msi',})
      is_expected.to contain_file('/opt/puppet/mock/3.3.0/install.ps1')
        .with_content(/\$master = \"puppetmaster.local\"/)
        .with_content(/\$ca = \"caserver.local\"/)
        .with_content(/\$source = \"https:\/\/puppetmaster.local:8140\/packages\/current\/windows\"/)
        .with_content(/\$package = \"puppet-enterprise-3.3.0.msi\"/)
        .with_content(/\$puppet = \"C:\\Program Files \(x86\)\\Puppet Labs\\Puppet Enterprise\\bin\\puppet.bat\"/)
    end
  end

  context 'Puppet Enterprise 3.8.x' do
    let(:facts) do
      {
        :pe_build => "3.8.0"
      }
    end
    let(:params) do
      {
        :puppetserver => 'puppetmaster.local',
        :caserver     => 'caserver.local',
      }
    end
    it 'with defaults' do
      is_expected.to contain_file('/opt/puppet/mock/3.8.0/windows')
      is_expected.to contain_pe_staging__file('puppet-enterprise-3.8.0-x64.msi').with({
      :source => 'https://s3.amazonaws.com/pe-builds/released/3.8.0/puppet-enterprise-3.8.0-x64.msi',
      :target => '/opt/puppet/mock/3.8.0/windows/puppet-enterprise-3.8.0-x64.msi',})
      is_expected.to contain_file('/opt/puppet/mock/3.8.0/install.ps1')
        .with_content(/\$master = \"puppetmaster.local\"/)
        .with_content(/\$ca = \"caserver.local\"/)
        .with_content(/\$source = \"https:\/\/puppetmaster.local:8140\/packages\/current\/windows\"/)
        .with_content(/\$package = \"puppet-enterprise-3.8.0-x64.msi\"/)
        .with_content(/\$puppet = \"C:\\Program Files \(x86\)\\Puppet Labs\\Puppet\\bin\\puppet.bat\"/)
    end
  end


  context 'Puppet Enterprise 2016.1.x' do
    let(:facts) do
      {
        :pe_build          => "2016.1.1",
        :aio_agent_version => "1.4.1"
      }
    end
    let(:params) do
      {
        :puppetserver => 'puppetmaster.local',
        :caserver     => 'caserver.local',
      }
    end
    it 'with defaults' do
      is_expected.to contain_file('/opt/puppet/mock/2016.1.1/windows')
      is_expected.to contain_pe_staging__file('puppet-agent-1.4.1-x64.msi').with({
      :source => 'https://s3.amazonaws.com/puppet-agents/2016.1/puppet-agent/1.4.1/repos/windows/puppet-agent-1.4.1-x64.msi',
      :target => '/opt/puppet/mock/2016.1.1/windows/puppet-agent-1.4.1-x64.msi',})
      is_expected.to contain_file('/opt/puppet/mock/2016.1.1/install.ps1')
        .with_content(/\$master = \"puppetmaster.local\"/)
        .with_content(/\$ca = \"caserver.local\"/)
        .with_content(/\$source = \"https:\/\/puppetmaster.local:8140\/packages\/current\/windows\"/)
        .with_content(/\$package = \"puppet-agent-1.4.1-x64.msi\"/)
        .with_content(/\$puppet = \"C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet.bat\"/)
    end
  end
end
