require 'spec_helper'

describe 'pe_winagent', type: :class do
  let(:public_dir) { '/opt/puppet/mock' }

  context 'Puppet Enterprise 2016.1.x' do
    let(:facts) do
      {
        pe_build: '2016.1.1',
        aio_agent_version: '1.4.1'
      }
    end
    let(:params) do
      {
        puppetserver: 'puppetmaster.local',
        caserver: 'caserver.local'
      }
    end
    it 'with defaults' do
      # rubocop:disable Metrics/LineLength
      is_expected.to contain_file('/opt/puppet/mock/2016.1.1/windows')
      is_expected.to contain_pe_staging__file('puppet-agent-1.4.1-x64.msi').with(source: 'https://s3.amazonaws.com/puppet-agents/2016.1/puppet-agent/1.4.1/repos/windows/puppet-agent-1.4.1-x64.msi',
                                                                                 target: '/opt/puppet/mock/2016.1.1/windows/puppet-agent-1.4.1-x64.msi')
      is_expected.to contain_file('/opt/puppet/mock/2016.1.1/install.ps1')
        .with_content(%r{/\^  $Master = 'puppetmaster.local'/})
        .with_content(%r{/If !\(\$CAServer\) { \$CAServer = \"caserver.local\" }/})
        .with_content(%r{/\$source = \"https:\/\/puppetmaster.local:8140\/packages\/current\/windows\"/})
        .with_content(%r{/\$package = \"puppet-agent-1.4.1-x64.msi\"/})
        .with_content(%r{/\$puppet = \"C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet.bat\"/})
      # rubocop:enable Metrics/LineLength
    end
  end

  context 'Puppet Enterprise 2016.2.x' do
    let(:facts) do
      {
        pe_build: '2016.4.2',
        aio_agent_version: '1.7.1'
      }
    end
    let(:params) do
      {
        puppetserver: 'puppetmaster.local',
        caserver: 'caserver.local',
        install_dir: 'c:\puppet'
      }
    end
    it 'with defaults' do
      # rubocop:disable Metrics/LineLength
      is_expected.to contain_file('/opt/puppet/mock/2016.4.2/windows')
      is_expected.to contain_pe_staging__file('puppet-agent-1.7.1-x64.msi').with(source: 'https://s3.amazonaws.com/puppet-agents/2016.4/puppet-agent/1.7.1/repos/windows/puppet-agent-1.7.1-x64.msi',
                                                                                 target: '/opt/puppet/mock/2016.4.2/windows/puppet-agent-1.7.1-x64.msi')
      is_expected.to contain_file('/opt/puppet/mock/2016.4.2/install.ps1')
        .with_content(/\[String\]\$Master = 'puppetmaster.local'/)
        .with_content(/\[String\]\$InstallDir = 'c:\\puppet'/)
      # .with_content(%r{/If !\(\$CAServer\) { \$CAServer = \"caserver.local\" }/})
      # .with_content(%r{/\$source = \"https:\/\/puppetmaster.local:8140\/packages\/current\/windows\"/})
      # .with_content(%r{/\$package = \"puppet-agent-1.4.1-x64.msi\"/})
      # .with_content(%r{/\$puppet = \"C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet.bat\"/})
      # rubocop:enable Metrics/LineLength
    end
  end
end
