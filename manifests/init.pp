# Puppet Entprise Windows 'Repo'
class pe_winagent(
  $puppetserver = $settings::server,
  $caserver     = $settings::ca_server,
  $public_dir   = $::pe_repo::public_dir
) inherits pe_repo {

  case $::pe_build {
    '2015.2.1' : {
      $msi        = 'puppet-agent-1.2.5-x64.msi'
      $s3_url     = "https://s3.amazonaws.com/puppet-agents/2015.2/puppet-agent/1.2.5/repos/windows/${msi}"
      $puppet_bat = 'C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat'
    }
    default    : {
      $msi        = "puppet-enterprise-${::pe_build}-x64.msi"
      $s3_url     = "https://s3.amazonaws.com/pe-builds/released/${::pe_build}/puppet-enterprise-${::pe_build}-x64.msi"
      $puppet_bat = 'C:\Program Files\Puppet Labs\Puppet Enterprise\bin\puppet.bat' 
    }
  }

  $file_dest  = "${public_dir}/${::pe_build}/windows/${msi}"

  file { "${public_dir}/${::pe_build}/windows" : ensure => directory }

  file { "${public_dir}/${::pe_build}/install.ps1" :
    ensure  => file,
    content => template("${module_name}/install.ps1.erb")
  }
  
  pe_staging::file { $msi :
    source => $s3_url,
    target => $file_dest
  }
}
