#pe_winagent
[![Build Status](https://travis-ci.org/matthewrstone/puppet-pe_winagent.svg?branch=master)](https://travis-ci.org/matthewrstone/puppet-pe_winagent)

##Description

pe_winagent is a module that helps with automating the installation process of Puppet Enterprise on Windows servers by riffing on the Linux 'curl' [installation method for Puppet Enterprise](https://docs.puppetlabs.com/pe/latest/install_agents.html) installation process. It currently supports Puppet Enterprise 3.3, 3.7, 3.8, 2015.x and 2016.x.

The module runs on the master and stores the Windows puppet agent MSI for installation.  The module also provides a PowerShell module to include in your Windows images to automate or kick off installation on demand.

##Installation

To install, clone this repository to your modules directory:

	git clone https://github.com/matthewrstone/puppet-pe_winagent.git pe_winagent

If you're seeing this from the Puppet Forge, a simple `puppet module install souldo/pe_winagent` will suffice.

## Usage

### pe_winagent

Apply the pe_winagent class to your puppetmaster and any compilers.  This will download the appropriate puppet agent MSI into the packages/current/windows directory.

#### Parameters

	puppetserver	= The Puppetmaster hostname, defaults to $settings::server
	caserver     	= The CA Server, defaults tp $settings::ca_server

### pe_winagent::powershell_host

This class deploys the PowerShell module to a Windows host, which is good for using a PowerShell host to remotely manage installation and upgrade of puppet agents across your Windows infrastructure.  This server must have a minimum of .NET 4.5 and Windows Management Framework 4.0 installed.  It can also be used to update the PowerShell module across your infrastructure when new releases of this puppet module are released.
	
---
	
### PowerShell Module: PuppetAgent

This is a PowerShell module with a few basic functions to install puppet either locally or remotely.  If you already have puppet installed on Windows hosts, this would be a good way to ugprade.

#### Cmdlets

	Test-PuppetInstall    = Verify the PS module is working and if a PE agent is installed.
	Install-Puppet        = Installs the puppet agent from a specified master.  Parameters below:		

	  Local options:
	  -Local			= Install Puppet agent locally
	  -Master			= Specify the Puppet Master which contains the MSI/install script.
	  -CertName		= Specify your FQDN for puppet registration.
	  -CAServer		= Specify a CA server for the puppet agent.

	  Remote options:
	  -Remote			= Install Puppet agent remotely
	  -ComputerList		= Either a single hostname or a CSV list of hosts to install remotely.

*Note: To install Puppet remotely you need to have PSRemoting enabled and have TrustedHosts configured.  If you don't know how to get started on that, you may want to consider the local method for now.*
		

**Install Puppet Remotely on a single host:**

	Install-Puppet -Remote -ComputerList myserver -Master my.puppetmaster.local
		
**Install Puppet Remotely on multiple hosts:**

	Install-Puppet -Remote -ComputerList myservers.csv -Master my.puppetmaster.local
		
**Upgrade the current node:**

	Install-Puppet -Local -Master my.puppetmaster.local

**Install Puppet with a different hostname**

	Install-Puppet -Master my.puppetmaster.local -CertName windowspuppetbox.iscool.local

### Notes

* Due to some issues dealing with self-signed certificates and the lack of a simple (-k) flag to bypass on Invoke-WebRequest, the Powershell script for the client is necessary at this time to accomodate all installations.

* This should work without puppet dependencies (other than pe_repo included in the Puppet Enterprise installation) and should technically work with all 2008/2012 editions, though it has only been tested with 2012 R2.

* More importantly than Windows version is the Powershell version.  The scripts were written and tested under Powershell 4.0.  The check your version, from a Powershell prompt type `$PSVersionTable.PSVersion`.  If your Major version is less than 4, [you may want to upgrade](https://www.microsoft.com/en-us/download/details.aspx?id=40855).

### Changelog

**v2.1.0**

- Puppet Enterprise 2016.x is supported now.
- Puppet Enterprise 3.3 is supported now.
- Fixed issue with local installation not passing `-CertName` or `-CAServer` parameters.
- Added a trap to kill the install process if the server can't be resolved or install script cannot be found.
- Renamed `Test-Puppet` to `Test-PuppetInstall`, which now returns that a) this module is here and b) if Puppet Enterprise is already installed (and what version).
- Removed the stubs for Uninstall-Puppet and Get-Puppet.
- Removed the documentation for using install.ps1 as a standalone script. That's as logical as using install.bash and copying it everywhere.


**v2.0.3**

- Cleaned up for ongoing future support of PE 2015 versions.  That sounds pretty epic but really I just changed it to base 2015 versions off of the new aio_agent_version fact if it exists to determine what agent package to download.

**v2.0.2**

- Added support for PE 2015.2.2 and agent 1.2.6.

**v2.0.1**

- Fixed a few puppet lint errors in the powershell host manifest.

**v2.0.0**

- Overhauled powershell scripts to include a module for remote agent installation. Many thanks to Chris Blodgett (@shotah) for the contributions and feedback on the PS side.

- Switched from using 'curl' to using pe_staging module (couldn't use nanliu/staging due to a conflict in earlier version of PE (ENTERPRISE-258).

- Added case statement to handle the new versioning for Puppet Agent in the PE 2015 releases.
