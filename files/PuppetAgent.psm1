#PuppetAgent.psm1
$ModuleVersion = "2.1.0"

Function Install-PuppetLocal {
	Param(
	  [Switch]$Local,
	  [Switch]$Remote,
	  [String]$ComputerList,
	  [Parameter(mandatory=$true)][String]$Master,
    [String]$CertName,
	  [String]$CAServer = $Master,
    [String]$Temp = "C:\Temp"
	)
  
  If (!(Test-Path $Temp)) { New-Item -Type Directory -Path $Temp -Force}

  Trap {
    Write-Host $_.Exception.Message -ForegroundColor Red
    Break
  }

    # Configure .NET Object to bypass self signed certificate for this session.
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
    $uri = "https://$Master`:8140/packages/current/install.ps1"
    $obj = New-Object System.Net.WebClient
    $link = $obj.DownloadString($uri)
    Write-Host "Getting installation script from Puppetmaster on $env:COMPUTERNAME..."
    Invoke-WebRequest $uri -Outfile $Temp\install.ps1 -ErrorAction Ignore

  Write-Host "Running Puppet Enterprise installation script on $env:COMPUTERNAME..."
  $params = @{
    Temp = $Temp
  }
  If ($CAServer) { $params += @{ CAServer = $CAServer } }
  If ($CertName) { $params += @{ CertName = $CertName } }
  Invoke-Expression "$Temp\install.ps1 @params"
}


Function Install-PuppetRemote {
Param (
    $Master,
    $Temp,
    $ComputerList
)

  $puppetopts = @{
    Master = $Master
    Temp = $Temp
    ComputerList = $ComputerList
  }

  Trap {
    Write-Host $_.Exception.Message -ForegroundColor Red
    Break
  }

  If ((Test-Path $ComputerList)) {
  $servers = (Get-Content $ComputerList)
  } else {
  $servers = $ComputerList }

  Invoke-Command -ComputerName $servers `
  -Credential $creds -ScriptBlock {
    Param ($puppetopts)
    $Master = $puppetopts.Master
    $Temp = $puppetopts.Temp
    $ComputerList = $puppetopts.ComputerList
    
    If ((Test-Path $Temp) -match 'False') {
    Write-Host "Creating Temporary Directory on $env:COMPUTERNAME..."
    New-Item -Path $Temp -ItemType Directory -Force | Out-Null
    }

    # Configure .NET Object to bypass self signed certificate for this session.
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
    $uri = "https://$Master`:8140/packages/current/install.ps1"
    $obj = New-Object System.Net.WebClient
    $link = $obj.DownloadString($uri)

    Write-Host "Downloading Installation Script on $env:COMPUTERNAME..."
    Invoke-WebRequest $uri -Outfile $Temp\install.ps1

    Write-Host "Running Puppet Enterprise installer script on $env:COMPUTERNAME..."
    Invoke-Expression "$Temp\install.ps1 -temp $Temp" 
  } -ArgumentList $puppetopts
}

Function Install-Puppet {
	Param(
	  [Switch]$Local,
	  [Switch]$Remote,
	  [String]$ComputerList,
	  [Parameter(mandatory=$true)][String]$Master,
    [String]$CertName,
	  [String]$CAServer = $Master,
    [String]$Temp = "C:\Temp"
	)

# Default to Local installation if not otherwise specified
    If (!($Local) -And !($Remote)) { $Local = $true }

# Bad form, kill the script if both options are given.
	If (($Local) -And ($Remote)) { 
	  "Don't be greedy.  There can only be one.  Remote or Local.  Decide." | Write-Host -ForegroundColor Red
	  Break
	} 

# Local Installation
    If ($Local -And !($Remote)) {
      $params = @{
        Master = $Master
        Temp   = $Temp
      }
      
# Add CA and CertName if specified
      If ($CertName) { $params += @{ CertName = $CertName } }
      If ($CAServer) { $params += @{ CAServer = $CAServer } }

      Install-PuppetLocal @params
	} 

# Remote Installation
    If ($Remote -And !($Local)) {
      If (!($ComputerList)) { 
        "You must specifcy ComputerList or server name for remote install.  Exiting!" | Write-Host -ForegroundColor Red
        Break
      }

      $params = @{
        Master       = $Master
        Temp         = $Temp
        ComputerList = $ComputerList
      }

      Install-PuppetRemote $params 
    }
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
