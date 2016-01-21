Function Get-IPDemo
{
$IP = Get-WmiObject -class Win32_NetworkAdapterConfiguration -Filter "IPEnabled =
$true"
"IP Address: " + $IP.IPAddress[0]
"Subnet: " + $IP.IPSubNet[0]
"GateWay: " + $IP.DefaultIPGateway
"DNS Server: " + $IP.DNSServerSearchOrder[0]
"FQDN: " + $IP.DNSHostName + "." + $IP.DNSDomain
} #end Get-IPDemo
# *** Entry Point To Script ***
Get-IPDemo