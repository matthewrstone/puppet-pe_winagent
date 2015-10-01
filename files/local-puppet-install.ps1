#For use with pe_winagent

Param (
  [string]$Temp = "c:\temp\puppet",
  [string]$Master
)

If (!($Master)) {
  Throw "Puppet master not specified. (Example: ./install-puppet-enterprise.ps1 -Master puppet.yourdomain.xyz)"
}

If ((Test-Path $Temp) -match 'False') {
  Write-Host "Creating Temporary Directory..."
  New-Item -Path c:\temp\puppet -ItemType Directory -Force
}

# Configure .NET Object to bypass self signed certificate for this session.
[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
$uri = "https://$Master`:8140/packages/current/install.ps1"
$obj = New-Object System.Net.WebClient
$link = $obj.DownloadString($uri)

Write-Host "Download Installation Script..."
Invoke-WebRequest $uri -Outfile $Temp\install.ps1

Write-Host "Running Puppet Enterprise installer script..."
Invoke-Expression "$Temp\install.ps1 -temp $Temp"
