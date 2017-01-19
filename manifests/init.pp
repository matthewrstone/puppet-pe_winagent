# Puppet Entprise Windows 'Repo'
class pe_winagent(
  String $server = lookup(
    'pe_winagent::server', String, 'first', $settings::server
  ),
  String $ca_server = lookup(
    'pe_winagent::ca_server', String, 'first', $settings::server
  ),
  Variant[String, Undef] $install_dir = lookup(
    'pe_winagent::install_dir', Variant[String, Undef], 'first', undef
  ),
  Variant[Enum['automatic','manual','disabled'], Undef] $startupmode = lookup(
    'pe_winagent::startupmode', Variant[String, Undef], 'first', undef
  ),
  Variant[String, Undef] $puppet_environment = lookup(
    'pe_winagent::environment', Variant[String, Undef], 'first', undef
  ),
  Variant[String, Undef] $accountuser = lookup(
    'pe_winagent::accountuser', Variant[String, Undef], 'first', undef
  ),
  Variant[String, Undef] $accountpass = lookup(
    'pe_winagent::accountpass', Variant[String, Undef], 'first', undef
  ),
  Variant[String, Undef] $accountdomain = lookup(
    'pe_winagent::accountdomain', Variant[String, Undef], 'first', undef
  ),
  Variant[String, Undef] $tempfolder = lookup(
    'pe_winagent::tempfolder', Variant[String, Undef], 'first', undef
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
    content => epp("${module_name}/install.ps1.epp", {
      server             => $server,
      install_dir        => $install_dir,
      ca_server          => $ca_server,
      puppet_environment => $puppet_environment,
      startupmode        => $startupmode,
      accountuser        => $accountuser,
      accountpass        => $accountpass,
      accountdomain      => $accountdomain,
      tempfolder         => $tempfolder,
      msi                => $msi
    }),
  }

  pe_staging::file { $msi :
    source => $s3_url,
    target => "${win_dir}/${msi}",
  }
}
