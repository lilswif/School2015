$args = "localhost"
foreach ($i in $args)
{Write-Host "Connecting to" $i "please wait ...";
Get-WmiObject -computername $i -class win32_UserAccount |
Select-Object Name, Disabled, PasswordRequired, SID, SIDType |
Where-Object {$_.PasswordRequired -eq 0} |
Sort-Object -property name}