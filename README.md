#pe_winagent

###Description

pe_winagent is a module that riffs on the Linux 'curl' [installation method for Puppet Enterprise](https://docs.puppetlabs.com/pe/latest/install_agents.html) to create a more fluid installation process for Windows nodes.  

The module runs on the master and co-opts the pe_repo class and space to retain the current .msi for Puppet Enterprise.  Once the MSI is mounted there are two options for installing, a local script or a powershell module for remote installation of Windows nodes.

###Installation

To install, clone this repository to your modules directory:

	git clone https://github.com/matthewrstone/puppet-pe_winagent.git pe_winagent

If you're seeing this from the Puppet Forge, a simple `puppet module install souldo/pe_winagent` will suffice.

### Usage

#### pe_winagent

Apply the pe_winagent class to your puppetmaster. and any compilers.  This will download the appropriate puppet agent MSI into the packages/current/windows directory.

**Parameters**

	puppetserver	= The Puppetmaster hostname, defaults to $settings::server
	caserver     = The CA Server, defaults tp $settings::ca_server

#### pe_winagent::powershell_host

Apply the pe_winagent::powershell_host class to a Windows server to serve as the PowerShell host,  i.e. the server you would remotely execute PowerShell from.  This server must have a minimum of .NET 4.5 and Windows Management Framework 4.0 installed.

---

#### PowerShell Script: installpuppet.ps1

This script will allow you to install Puppet locally.  Good for embedding into your provisioning scripts if you have a static Puppetmaster or as a one and done script for getting the most recent version from the Puppetmaster and upgrading the agent.

**Parameters**

	temp		= set a temporary directory, defaults to c:\temp
	master		= the hostname of your puppetmaster

**Usage**

	Install Puppet
	./installpuppet.ps1 -Master mypuppetmaster.internet.local
	
---
	
#### PowerShell Module: PuppetAgent

This is a powershell module with a few basic functions to install puppet either locally or remotely.  If you already have puppet installed on Windows hosts, this would be a good way to ugprade.

**Cmdlets**

	Test-Puppet    = Verify if you are a Jedi.
	Get-Puppet     = Return the current version of the Puppet Agent installed.
	Install-Puppet = Installs the puppet agent (retreived from the puppetmaster).
		
**Usage**

		Note: To install Puppet remotely you need to have PSRemoting enabled and have TrustedHosts configured.  If you don't know how to get started on that, you may want to consider the local method for now.
		
	Install Puppet Remotely on a single host:
	Install-Puppet -Remote -ComputerList myserver -Master my.puppetmaster.local
		
	Install Puppet Remotely on multiple hosts:
	Install-Puppet -Remote -ComputerList (Get-Content myservers.csv) -Master my.puppetmaster.local
		
	Upgrade the current node:
	Install-Puppet -Local -Master my.puppetmaster.local

### Notes

* Due to some issues dealing with self-signed certificates and the lack of a simple (-k) flag to bypass on Invoke-WebRequest, the Powershell script for the client is necessary at this time to accomodate all installations.

* This should work without puppet dependencies (other than pe_repo included in the Puppet Enterprise installation) and should technically work with all 2008/2012 editions, though it has only been tested with 2012 R2.

* More importantly that Windows version is the Powershell version.  The scripts were written and tested under Powershell 4.0.  The check your version, from a Powershell prompt type `$PSVersionTable.PSVersion`.  If your Major version is less than for, [you may want to upgrade](https://www.microsoft.com/en-us/download/details.aspx?id=40855).

### Changelog
**v2.0**

- Built a powershell module, 'cuz Install-Puppet looks cool.

- Switched from using 'curl' to using pe_staging module (couldn't use nanliu/staging due to a conflict in earlier version of PE (ENTERPRISE-258).

- Added case statement to handle the new versioning for Puppet Agent in the PE 2015 releases.

- Overhauled powershell scripts for remote agent installation via PS Remoting.