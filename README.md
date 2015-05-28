#pe_winagent

###Description

pe_winagent is a module that riffs on the Linux 'curl' [installation method for Puppet Enterprise](https://docs.puppetlabs.com/pe/latest/install_agents.html) to create a more fluid installation process for Windows nodes.  

The module runs on the master and co-opts the pe_repo class and space to retain the current .msi for Puppet Enterprise.  I've also included a Powershell script to include on your Windows images if you want to fully automate the installation process from zero to Puppet.

###Installation

#### Get the Module
To install, clone this repository to your modules directory:

	git clone https://github.com/matthewrstone/puppet-pe_winagent.git pe_winagent

Then apply the pe_winagent class to your Puppetmaster (and additional compile masters if needed).

#### Client Script

The next step is the Powershell script in `pe_winagent/files`.  The `install-puppet-enterprise.ps1` script is intended to be run from the Windows client server.

###Parameters

#### Module Parameters

	puppetserver => <fqdn of puppet master or vip>
    caserver     => <fqdn of CA>

#### Client Script Parameters

When running the client script, it only accepts two parameters:

	-master		fqdn of the puppet master
	-temp		the work directory for the installer

###Usage

* Apply the pe_winagent module to your puppetmaster (and additional compilers if needed).

* Copy the install-puppet-enterprise.ps1 script to either your Windows image or just a clean new Windows server.

* From the Windows server, run ./install-puppet-enterprise.ps1 -master <your puppet master>

* Once the script has completed you should be registered with Puppet.  Accept the cert and give it a whirl. 


### Notes

* Due to some issues dealing with self-signed certificates and the lack of a simple (-k) flag to bypass on Invoke-WebRequest, the Powershell script for the client is necessary at this time to accomodate all installations.