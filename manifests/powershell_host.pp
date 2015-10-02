class pe_winagent::powershell_host(
	$ps_home = 'C:\windows\system32\windowspowershell\v1.0',
) {
  file { 'PuppetAgentModuleDirectory' :
    ensure => directory,
    path   => "${ps_home}\\Modules\\PuppetAgent",
  }

  file { 'PuppetAgentModule' :
    path   => "${ps_home}\\Modules\\PuppetAgent\\PuppetAgent.psm1", 
    ensure => file,
    source => "puppet:///modules/${module_name}/PuppetAgent.psm1",
    source_permissions => ignore,
    require => File['PuppetAgentModuleDirectory'],
  }

}
