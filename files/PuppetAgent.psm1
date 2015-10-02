#PuppetAgent.psm1
Function Install-PuppetLocal {
  Param($puppetopts)
  If (!(Test-Path $Temp)) { New-Item -Type Directory -Path $Temp -Force}
  # Configure .NET Object to bypass self signed certificate for this session.
  [System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
  $uri = "https://$Master`:8140/packages/current/install.ps1"
  $obj = New-Object System.Net.WebClient
  $link = $obj.DownloadString($uri)

  Write-Host "Getting installation script from Puppetmaster on $env:COMPUTERNAME..."
  Invoke-WebRequest $uri -Outfile $Temp\install.ps1

  Write-Host "Running Puppet Enterprise installation script on $env:COMPUTERNAME..."
  Invoke-Expression "$Temp\install.ps1 -temp $Temp"
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

    If (!($Local) -and !($Remote)) { $Local = $true }
	If (($Local) -and ($Remote)) { 
	  "Don't be greedy.  There can only be one.  Remote or Local.  Decide." | Write-Host -ForegroundColor Red
	  break
	} elseif ($Local) {
	    Install-PuppetLocal -Master $Master -Temp $Temp
	} elseif ($Remote) {
        If (!($ComputerList)) { 
            "You must specifcy ComputerList or server name for remote install.  Exiting!" | Write-Host -ForegroundColor Red
            break
        }
        Install-PuppetRemote -Master $Master -Temp $Temp -ComputerList $ComputerList 
    }
}
Function Uninstall-Puppet {}
Function Get-Puppet {
	Invoke-Command -ScriptBlock { $puppetVersion = puppet --version; $puppetVersion | Write-Host -ForegroundColor Green }
}
function Test-Puppet {
	Write-Host "I am a Jedi" -ForegroundColor Green
}
