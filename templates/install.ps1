Invoke-WebRequest http://<%= @puppetserver %>:8140/packages/current/install.ps1 | \
Invoke-Command –ScriptBlock { msiexec $_ /q PUPPET_MASTER_SERVER=<%= @puppetserver %> \
PUPPET_CA_SERVER=<%= @caserver %> }

