# remote-install-puppet.ps1
Param(
  [String]$Master,
  [String]$Temp,
  [String]$ComputerList
)

$puppetopts = @{
  Master = $Master
  Temp = $Temp
}

Invoke-Command -ComputerName $ComputerList `
-Credential $creds -FilePath ".\installpuppet.ps1" `
-ArgumentList $puppetopts