# Puppet Entprise Windows 'Repo'
class pe_winagent(
  String $server = lookup(
    'pe_winagent::server', String, 'first', $settings::server
  ),
  String $ca_server = lookup(
    'pe_winagent::ca_server', String, 'first', $settings::server
  ),
  String $install_dir = lookup(
    'pe_winagent::install_dir', String, 'first', undef
  ),
  Enum['automatic','manual','disabled'] $startupmode  = lookup(
    'pe_winagent::startupmode', String, 'first', undef
  ),
  String $environment = lookup(
    'pe_winagent::environment', String, 'first', undef
  ),
  String $accountuser = lookup(
    'pe_winagent::accountuser', String, 'first', undef
  ),
  String $accountpass = lookup(
    'pe_winagent::accountpass', String, 'first', undef
  ),
  String $accountdomain = lookup(
    'pe_winagent::accountdomain', String, 'first', undef
  ),
  String $tempfolder = lookup(
    'pe_winagent::tempfolder', String, 'first', undef
  )
) {

  contain pe_repo
  $public_dir  = $::pe_repo::public_dir
  $s3_link     = 'https://s3.amazonaws.com'
  $win_dir     = "${public_dir}/${::pe_build}/windows"
  $build_dir   = chop(chop($::pe_build))
  $puppet_root = 'C:\Program Files\Puppet Labs'
  $msi         = "puppet-agent-${::aio_agent_version}-x64.msi"
  $s3_path     = "puppet-agents/${build_dir}/puppet-agent/${::aio_agent_version}/repos/windows"
  $s3_url      = "${s3_link}/${s3_path}/${msi}"
  $puppet_bat  = "${puppet_root}\\Puppet\\bin\\puppet.bat"

  file { $win_dir : ensure => directory }

  file { "${public_dir}/${::pe_build}/install.ps1" :
    ensure  => file,
    content => epp("${module_name}/install.ps1.epp"),
  }

  pe_staging::file { $msi :
    source => $s3_url,
    target => "${win_dir}/${msi}",
  }
}
