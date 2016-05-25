require 'spec_helper'

describe 'pe_winagent::powershell_host' do
  context 'with defaults' do
    it {
      is_expected.to contain_file('PuppetAgentModuleDirectory').with({
        :ensure             => :directory,
        :path               => "C:\\windows\\system32\\windowspowershell\\v1.0\\Modules\\PuppetAgent",
        :source_permissions => :ignore,
      })
      
      is_expected.to contain_file('PuppetAgentModule').with({
        :ensure             => :file,
        :path               => "C:\\windows\\system32\\windowspowershell\\v1.0\\Modules\\PuppetAgent\\PuppetAgent.psm1",
        :source             => 'puppet:///modules/pe_winagent/PuppetAgent.psm1',
        :source_permissions => :ignore,
      })

    }
        
  end
  context 'with different ps_home directory' do
    let(:params) {
      { :ps_home => 'C:\mock' }
    }

    it {
      is_expected.to contain_file('PuppetAgentModuleDirectory').with({
        :ensure             => :directory,
        :path               => "C:\\mock\\Modules\\PuppetAgent",
        :source_permissions => :ignore,
      })

      is_expected.to contain_file('PuppetAgentModule').with({
        :ensure             => :file,
        :path               => "C:\\mock\\Modules\\PuppetAgent\\PuppetAgent.psm1",
        :source             => 'puppet:///modules/pe_winagent/PuppetAgent.psm1',
        :source_permissions => :ignore,
      })

    }

  end

end

