# Installs Powershell Module on a Windows host
class pe_winagent::powershell_host(
  $ps_home = 'C:\windows\system32\windowspowershell\v1.0',
) {

  File { source_permissions => ignore }
  file { 'PuppetAgentModuleDirectory' :
    ensure => directory,
    path   => "${ps_home}\\Modules\\PuppetAgent",
  }

  file { 'PuppetAgentModule' :
    ensure  => file,
    path    => "${ps_home}\\Modules\\PuppetAgent\\PuppetAgent.psm1",
    source  => "puppet:///modules/${module_name}/PuppetAgent.psm1",
    require => File['PuppetAgentModuleDirectory'],
  }

}
