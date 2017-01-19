$install_dir = undef
$puppetserver = undef
$caserver = undef
$puppet_bat = undef
$msi = undef

file { "/tmp/install.ps1" :
    ensure  => file,
    content => epp("/Users/mastone/Code/puppet_modules/pe_winagent/templates/install.ps1.epp"),
  }
