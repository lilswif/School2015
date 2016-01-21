Function Get-IPObject([bool]$IPEnabled = $true)
{
Get-WmiObject -class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = $IPEnabled"
} #end Get-IPObject
Function Format-NonIPOutput($IP)
{
Begin { "Index # Description" }
Process {
ForEach ($i in $ip)
{
Write-Host $i.Index `t $i.Description
} #end ForEach
} #end Process
} #end Format-NonIPOutPut
$ip = Get-IPObject -IPEnabled $False
Format-NonIPOutput($ip)