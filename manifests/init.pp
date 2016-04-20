# Puppet Entprise Windows 'Repo'
class pe_winagent(
  $puppetserver = $settings::server,
  $caserver     = $settings::ca_server,
) {
  include pe_repo

  $public_dir  = $::pe_repo::public_dir
  $s3_link     = 'https://s3.amazonaws.com'
  $puppet_root = 'C:\Program Files\Puppet Labs'
  $win_dir     = "${public_dir}/${::pe_build}/windows"
  $build_dir   = chop(chop($::pe_build))

  if $::aio_agent_version {
    $msi         = "puppet-agent-${::aio_agent_version}-x64.msi"
    $s3_path     = "puppet-agents/${build_dir}/puppet-agent/${::aio_agent_version}/repos/windows"
    $s3_url      = "${s3_link}/${s3_path}/${msi}"
    $puppet_bat  = "${puppet_root}\\Puppet\\bin\\puppet.bat"
  } else {
    $msi        = "puppet-enterprise-${::pe_build}-x64.msi"
    $s3_path    = "pe-builds/released/${::pe_build}"
    $s3_url     = "${s3_link}/pe-builds/released/${::pe_build}/${msi}"
    $puppet_bat = "${puppet_root}\\Puppet Enterprise\\bin\\puppet.bat"
  }

  file { $win_dir : ensure => directory }

  file { "${public_dir}/${::pe_build}/install.ps1" :
    ensure  => file,
    content => template("${module_name}/install.ps1.erb"),
  }
  
  pe_staging::file { $msi :
    source => $s3_url,
    target => "${win_dir}/${msi}",
  }
}
