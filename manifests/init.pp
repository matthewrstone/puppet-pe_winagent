# Puppet Entprise Windows 'Repo'
class pe_winagent(
  $puppetserver = $settings::server,
  $caserver     = $settings::ca_server,
) inherits pe_repo {
  $msi        = "puppet-enterprise-${::pe_build}-x64.msi"
  $file_dest  = "${public_dir}/${::pe_build}/${msi}"
  $s3_url     = "https://s3.amazonaws.com/pe-builds/released/${::pe_build}/puppet-enterprise-${::pe_build}-x64.msi"

  file { "${public_dir}/${::pe_build}/install.ps1" :
    ensure  => file,
    content => template("${module_name}/install.ps1")
  }
  exec { 'Download Windows PE Agent':
    command   => "/usr/bin/curl -o ${msi} ${s3_url}",
    creates   => $file_dest,
    logoutput => true,
  }
}

