# Set-myIP.ps1
# Quick and dirty IP address setter

Param ($IP4,$IP6)

$Network = "192.168.10."
$Network6 = "2001:db8:0:10::"
$IPv4 = $Network + "$IP4"
$IPv6 = $Network6 + "$IP6"
$Gateway4 = $Network + "1"
$Gateway6 = $Network6 + "1"

$Nic = Get-NetAdapter -name Ethernet
$Nic | Set-NetIPInterface -DHCP Disabled
$Nic | New-NetIPAddress -AddressFamily IPv4 `
                        -IPAddress $IPv4 `
                        -PrefixLength 24 `
                        -type Unicast `
                        -DefaultGateway $Gateway4
Set-DnsClientServerAddress -InterfaceAlias $Nic.Name `
                           -ServerAddresses 192.168.10.2,2001:db8:0:10::2
$NIC |  New-NetIPAddress -AddressFamily IPv6 `
                         -IPAddress $IPv6 `
                         -PrefixLength 64 `
                         -type Unicast `
                         -DefaultGateway $Gateway6
ipconfig /all

