#PuppetAgent.psm1
$ModuleVersion = "3.0.0"
Function Install-Puppet {
	  Param(
	      [Parameter(mandatory=$true)][String]$Master,
        [String]$CertName,
        [String]$CAServer = $Master,
        [String]$Temp,
        [String]$InstallDir,
        [String]$Environment,
        [String]$StartupMode,
        [String]$AccountUser,
        [String]$AccountPassword,
        [String]$AccountDomain
    )
    If ($Temp) {
        If (!(Test-Path $Temp)) { New-Item -Type Directory -Path $Temp -Force }
    } else {
        $Temp = $env:TEMP
    }

    # Configure .NET Object to bypass self signed certificate for this session.
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
    $url = "https://$Master`:8140/packages/current/install.ps1"
    $obj = New-Object System.Net.WebClient
    $link = $obj.DownloadString($url)
    Write-Host "Getting installation script from Puppetmaster on $env:COMPUTERNAME..."
    Invoke-WebRequest $url -Outfile $Temp\install.ps1 -ErrorAction Ignore

    # Compile options and pass to the install script.
    $params = @{ Temp = $Temp }
    If ($CAServer) { $params += @{ CAServer = $CAServer } }
    If ($CertName) { $params += @{ CertName = $CertName } }
    If ($InstallDir) { $params += @{ InstallDir = $InstallDir } }
    If ($StartupMode) { $params += @{ StartupMode = $StartupMode } }
    If ($InstallDir) { $params += @{ InstallDir = $InstallDir } }
    If ($Master) { $params += @{ Master = $Master } }
    If ($Environment) { $params += @{ Environment = $Environment } }
    If ($AccountUser) { $params += @{ AccountUser = $AccountUser } }
    If ($AccountPassword) { $params += @{ AccountPassword = $AccountPassword } }
    If ($AccountDomain) { $params += @{ AccountDomain = $AccountDomain } }

    Write-Host "Running Puppet Enterprise installation script on $env:COMPUTERNAME..."
    Invoke-Expression "$Temp\install.ps1 @params"
}

function Test-PuppetInstall {
	  Write-Host "PE WinAgent PowerShell Module $ModuleVersion is installed." -ForegroundColor Green
        try {
            $PuppetVersion = Invoke-Expression -Command "puppet --version"
            Write-Host "Puppet Agent Version $PuppetVersion is installed."
        } catch {
            Write-Host "Puppet Agent is not installed."
        }
}
