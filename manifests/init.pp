# Puppet Entprise Windows 'Repo'
class pe_winagent(
  $puppetserver = $settings::server,
  $caserver     = $settings::ca_server,
#  $base_path = $::pe_repo::base_path,
#  $repo_dir  = $::pe_repo::repo_dir,
#  $prefix    = $::pe_repo::prefix,
#  $master    = $::settings::server,
#  $repo_dir  = $::pe_repo::repo_dir,
) inherits pe_repo {
#  $public_dir = "${repo_dir}/${prefix}/public"
  $msi        = "puppet-enterprise-${::pe_build}-x64.msi"
  $file_dest  = "${public_dir}/${::pe_build}/${msi}"
  $s3_url     = "https://s3.amazonaws.com/pe-builds/released/${::pe_build}/puppet-enterprise-${::pe_build}-x64.msi"

  file { "${public_dir}/${::pe_build}/install.ps1" :
    ensure  => file,
    content => template("${module_name}/install.ps1")
  }
  exec { 'Download Windows PE Agent':
    command   => "/usr/bin/curl -o ${msi} ${s3_url}",
#    cwd       => "${public_dir}/${::pe_build}",
    creates   => $file_dest,
    logoutput => true,
  }
}

