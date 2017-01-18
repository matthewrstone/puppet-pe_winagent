# Puppet Entprise Windows 'Repo'
class pe_winagent(
  $puppetserver = hiera('pe_winagent::puppetserver', $settings::server),
  $caserver     = hiera('pe_winagent::caserver', $settings::ca_server),
  $install_dir  = undef
) {

  contain pe_repo
  $public_dir  = $::pe_repo::public_dir
  $s3_link     = 'https://s3.amazonaws.com'
  $win_dir     = "${public_dir}/${::pe_build}/windows"
  $build_dir   = chop(chop($::pe_build))

  if $::aio_agent_version {
    $puppet_root = 'C:\Program Files\Puppet Labs'
    $msi         = "puppet-agent-${::aio_agent_version}-x64.msi"
    $s3_path     = "puppet-agents/${build_dir}/puppet-agent/${::aio_agent_version}/repos/windows"
    $s3_url      = "${s3_link}/${s3_path}/${msi}"
    $puppet_bat  = "${puppet_root}\\Puppet\\bin\\puppet.bat"
  } else {
    if $::pe_build =~ /^3.3/ {
      $msi = "puppet-enterprise-${::pe_build}.msi"
      $puppet_root = 'C:\Program Files (x86)\Puppet Labs'
      $puppet_bat  = "${puppet_root}\\Puppet Enterprise\\bin\\puppet.bat"
    } else {
      $msi = "puppet-enterprise-${::pe_build}-x64.msi"
      $puppet_root = 'C:\Program Files\Puppet Labs'
      $puppet_bat  = "${puppet_root}\\Puppet\\bin\\puppet.bat"
    }
    $s3_path    = "pe-builds/released/${::pe_build}"
    $s3_url     = "${s3_link}/pe-builds/released/${::pe_build}/${msi}"
  }

  file { $win_dir : ensure => directory }

  file { "${public_dir}/${::pe_build}/install.ps1" :
    ensure  => file,
    content => template("${module_name}/install.ps1.epp"),
  }

  pe_staging::file { $msi :
    source => $s3_url,
    target => "${win_dir}/${msi}",
  }
}
