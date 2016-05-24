require 'spec_helper'

describe 'pe_winagent', :type => :class do

  let(:public_dir) { '/opt/puppet/mock' }

  context 'Puppet Enterprise 3.3.x' do

    let(:facts) do
      {
        :pe_build => "3.3.0"
      }

    end
    
    it {
      is_expected.to contain_file('/opt/puppet/mock/3.3.0/windows')
    }

    it { is_expected.to contain_pe_staging__file('puppet-enterprise-3.3.0.msi').with({ 
      :source => 'https://s3.amazonaws.com/pe-builds/released/3.3.0/puppet-enterprise-3.3.0.msi',
      :target => '/opt/puppet/mock/3.3.0/windows/puppet-enterprise-3.3.0.msi',})
    }

  end

  context 'Puppet Enterprise 2016.1.x' do
    
    let(:facts) do
      {
        :pe_build          => "2016.1.1",
        :aio_agent_version => "1.4.1"
      }
    end

    it {
      is_expected.to contain_file('/opt/puppet/mock/2016.1.1/windows')
    }

    it { is_expected.to contain_pe_staging__file('puppet-agent-1.4.1-x64.msi').with({
      :source => 'https://s3.amazonaws.com/puppet-agents/2016.1/puppet-agent/1.4.1/repos/windows/puppet-agent-1.4.1-x64.msi',
      :target => '/opt/puppet/mock/2016.1.1/windows/puppet-agent-1.4.1-x64.msi',})
    }
  end
end
