class pe_winagent::powershell_host(
	$ps_home = 'C:\windows\system32\windowspowershell\v1.0',
	$ps_module_home = "${ps_home}\\modules"
) {
	file { 'PuppetAgentModule' :
	  path   => "${ps_home}\\Modules\\PuppetAgent\\PuppetAgent.psm1", 
	  ensure => directory,
	  source => "puppet:///modules/${module_name}/PuppetAgent.psm1",
	  source_permissions => ignore,
	}

#	exec { 'Profile Update' :
#      command => "Add-Content ${ps_home}\\profile.ps1 \"Import-Module PuppetAgent\"",
#      refreshonly => true,
#      provider => powershell,
#      subscribe   => File['PuppetAgentModule'],
#    }

}
