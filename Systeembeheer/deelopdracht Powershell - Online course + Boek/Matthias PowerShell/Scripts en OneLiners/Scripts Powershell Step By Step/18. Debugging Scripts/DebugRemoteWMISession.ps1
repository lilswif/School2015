# DebugRemoteWMISession.ps1
# ed wilson, msft, 4/8/12
# PowerShell 3.0 Step By Step
# chapter 16
# Scripting Techniques, Troubleshooting, debugging

$oldDebugPreference = $DebugPreference
$DebugPreference = "continue"
$credential = Get-Credential
$cn = Read-Host -Prompt "enter a computer name"
Write-Debug "user name: $($credential.UserName)"
Write-Debug "password: $($credential.GetNetworkCredential().Password)"
Write-Debug "$cn is up: 
  $(Test-Connection -Computername $cn -Count 1 -BufferSize 16 -quiet)"
Get-WmiObject win32_bios -cn $cn -Credential $credential
$DebugPreference = $oldDebugPreference