Invoke-WebRequest http://<%= @puppetserver %>:8140/packages/current/puppet-enterprise-<%= @pe_build %>-x64.msi | \
Invoke-Command –ScriptBlock { msiexec $_ /q PUPPET_MASTER_SERVER=<%= @puppetserver %> \
PUPPET_CA_SERVER=<%= @caserver %> }

