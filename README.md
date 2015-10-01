#pe_winagent

###Description

pe_winagent is a module that riffs on the Linux 'curl' [installation method for Puppet Enterprise](https://docs.puppetlabs.com/pe/latest/install_agents.html) to create a more fluid installation process for Windows nodes.  

The module runs on the master and co-opts the pe_repo class and space to retain the current .msi for Puppet Enterprise.  I've also included a Powershell script to include on your Windows images if you want to fully automate the installation process from zero to Puppet.

###Installation

#### Get the Module
To install, clone this repository to your modules directory:

	git clone https://github.com/matthewrstone/puppet-pe_winagent.git pe_winagent

If you're seeing this from the Puppet forge, a simple `puppet module install souldo/pe_winagent` will suffice.

Then apply the pe_winagent class to your Puppetmaster (and additional compile masters if needed).

#### Client Script

The next step is the Powershell script in `pe_winagent/files`.  The `local-puppet-install` script is intended to be run from the Windows client server.  You can alternately use the remote method with the `remote-puppet-install` and `remote-puppet` scripts.

##### Which is better? #####

Well, think of it this way.  If you use local and you can hard code the parameters...say if you are absolutely certain of your master server settings for the long haul, you can add that script to the first run when a Windows Server is provisioned and automate adding that node to Puppet.

Otherwise, if you are bringing servers up and then going through an install process, you can target many at once with the remote scripts.  However, you need to know how to configure WinRM so you can execute command remotely.

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

Now you must choose your own adventure...

#### Local Installation Method ####
* Copy the local-puppet-install script to either your Windows image or just a clean new Windows server.

* From the Windows server, run ./local-puppet-install -master <your puppet master>

* Once the script has completed you should be registered with Puppet.  Accept the cert and give it a whirl. 

#### PS Remote Method ####
* Copy the remote-puppet-install.ps1 and remote-puppet.ps1 scripts to a server/workstation that is a trusted host for WinRM.

* Create an optional list of machines you wish to install Puppet on.  This list will be the value of the -ComputerList parameter.  Use a single host name as the value if you only have one machine to work with.

* Run the remote installer:

		./remote-puppet-install `
		-ComputerList <computerlist.txt/server name> `
		-Master <your.puppet.master.com> `
		-Temp <optional, only if you don't want to use c:\temp>
		
* Once the script has completed, puppet should be installed and configured on the Windows server.

### Notes

* Due to some issues dealing with self-signed certificates and the lack of a simple (-k) flag to bypass on Invoke-WebRequest, the Powershell script for the client is necessary at this time to accomodate all installations.

* This should work without puppet dependencies (other than pe_repo included in the Puppet Enterprise installation) and should technically work with all 2008/2012 editions, though it has only been tested with 2012 R2.

* More importantly that Windows version is the Powershell version.  The scripts were written and tested under Powershell 4.0.  The check your version, from a Powershell prompt type `$PSVersionTable.PSVersion`.  If your Major version is less than for, [you may want to upgrade](https://www.microsoft.com/en-us/download/details.aspx?id=40855).

### Changelog
**v1.0.2**

- Switched from using 'curl' to using pe_staging module (couldn't use nanliu/staging due to a conflict in earlier version of PE (ENTERPRISE-258).

- Added case statement to handle the new versioning for Puppet Agent in the PE 2015 releases.

- Overhauled powershell scripts for remote agent installation via PS Remoting.