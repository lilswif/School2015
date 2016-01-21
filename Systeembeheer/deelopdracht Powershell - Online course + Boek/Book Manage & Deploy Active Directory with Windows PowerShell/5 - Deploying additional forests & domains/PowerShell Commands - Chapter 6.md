syntax Rename-Computer

Rename-Computer -NewName na-dc-05 -Restart:$False

Get-NetIPAddress -AddressFamily IPv4 `
               | Format-Table -Auto ifIndex,InterfaceAlias,IPAddress

Get-NetIPAddress | Get-Member
$Nic10 = Get-NetAdapter -ifIndex 3
$Nic11 = Get-NetAdapter -ifIndex 4
$Nic10 | Set-NetIPInterface -DHCP Disabled
$Nic11 | Set-NetIPInterface -DHCP Disabled
$Nic10 | New-NetIPAddress -AddressFamily IPv4 `
                          -IPAddress 192.168.10.5 `
                          -PrefixLength 24 `
                          -type Unicast `
                          -DefaultGateway 192.168.10.1
$Nic11 | New-NetIPAddress -AddressFamily IPv4 `
                          -IPAddress 192.168.11.5 `
                          -PrefixLength 24 `
                          -type Unicast
$Nic10 | New-NetIPAddress -AddressFamily IPv6 `
                          -IPAddress 2001:db8:0:10::5 `
                          -PrefixLength 64 `
                          -type Unicast `
                          -DefaultGateway 2001:db8:0:10::1
$Nic11 | New-NetIPAddress -AddressFamily IPv6 `
                          -IPAddress 2001:db8:0:11::5 `
                          -PrefixLength 64 `
                          -type Unicast

Set-DnsClientServerAddress -InterfaceAlias $Nic10.Name `
                           -ServerAddresses 192.168.10.2,2001:db8:0:10::2 `
                           -PassThru
Set-DnsClientServerAddress -InterfaceAlias $Nic11.Name `
                           -ServerAddresses 127.0.0.1,::1 `
                           -PassThru

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Update-Help -SourcePath \\cpr-labhost-6\pshelp -force

$myDomCreds = Get-Credential -UserName "TreyResearch\Charlie" `
                             -Message "Enter Domain Password"
Test-ADDSDomainInstallation `
      -NoGlobalCatalog:$false `
      -CreateDnsDelegation:$True `
      -Credential $myDomCreds `
      -DatabasePath "C:\Windows\NTDS" `
      -DomainMode "Win2012R2" `
      -DomainType "ChildDomain" `
      -InstallDns:$True `
      -LogPath "C:\Windows\NTDS" `
      -NewDomainName "NorthAmerica" `
      -NewDomainNetbiosName "NORTHAMERICA" `
      -ParentDomainName "TreyResearch.net" `
      -NoRebootOnCompletion:$False `
      -SiteName "Default-First-Site-Name" `
      -SysvolPath "C:\Windows\SYSVOL" `
      -Force:$True

Install-ADDSDomain -NoGlobalCatalog:$False `
                   -CreateDnsDelegation:$True `
                   -Credential $myDomCreds `
                   -DatabasePath "C:\Windows\NTDS" `
                   -DomainMode "Win2012R2" `
                   -DomainType "ChildDomain" `
                   -InstallDns:$True `
                   -LogPath "C:\Windows\NTDS" `
                   -NewDomainName "NorthAmerica" `
                   -NewDomainNetbiosName "NORTHAMERICA" `
                   -ParentDomainName "TreyResearch.net" `
                   -NoRebootOnCompletion:$False `
                   -SiteName "Default-First-Site-Name" `
                   -SysvolPath "C:\Windows\SYSVOL" `
                   -Force:$True

Get-ADGroupMember -Identity Administrators | ft -auto Name,DistinguishedName

Rename-Computer -NewName wing-dc-06 -Restart:$False

Get-NetIPAddress -AddressFamily IPv4 `
                | Format-Table -Auto  ifIndex,InterfaceAlias,IPAddress
$Nic12 = Get-NetAdapter -ifIndex 3
$Nic10 = Get-NetAdapter -ifIndex 6
$Nic10 | Set-NetIPInterface -DHCP Disabled
$Nic12 | Set-NetIPInterface -DHCP Disabled
$Nic12 | New-NetIPAddress -AddressFamily IPv4 `
                          -IPAddress 192.168.12.6 `
                          -PrefixLength 24 `
                          -type Unicast                           
$Nic10 | New-NetIPAddress -AddressFamily IPv4 `
                          -IPAddress 192.168.10.6 `
                          -PrefixLength 24 `
                          -type Unicast `
                          -DefaultGateway 192.168.10.1
$Nic12 | New-NetIPAddress -AddressFamily IPv6 `
                          -IPAddress 2001:db8:0:12::6 `
                          -PrefixLength 64 `
                          -type Unicast
$Nic10 | New-NetIPAddress -AddressFamily IPv6 `
                          -IPAddress 2001:db8:0:10::6 `
                          -PrefixLength 64 `
                          -type Unicast `
                          -DefaultGateway 2001:db8:0:10::1
Set-DnsClientServerAddress -InterfaceAlias $Nic10.Name `
                           -ServerAddresses 192.168.10.2,2001:db8:0:10::2 `
                           -PassThru
Set-DnsClientServerAddress -InterfaceAlias $Nic12.Name `
                           -ServerAddresses 127.0.0.1,::1 `
                           -PassThru

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Update-Help -SourcePath \\cpr-labhost-6\pshelp -force

$myDomCreds = Get-Credential -UserName "TreyResearch\Administrator " `
                             -Message "Enter Domain Password"
Test-ADDSDomainInstallation  -NoGlobalCatalog:$false `
                             -Credential $myDomCreds `
                             -DatabasePath "C:\Windows\NTDS" `
                             -DomainMode "Win2012R2" `
                             -DomainType "TreeDomain" `
                             -InstallDns:$True `
                             -LogPath "C:\Windows\NTDS" `
                             -NewDomainName "WingtipToys.com" `
                             -NewDomainNetbiosName "WINGTIP" `
                             -ParentDomain "TreyResearch.net"
                             -NoRebootOnCompletion:$True  `
                             -SiteName "Default-First-Site-Name" `
                             -SysvolPath "C:\Windows\SYSVOL" `
                             -Force:$True

Install-ADDSDomain -NoGlobalCatalog:$false `
                   -Credential $myDomCreds `
                   -DatabasePath "C:\Windows\NTDS" `
                   -DomainMode "Win2012R2" `
                   -DomainType "TreeDomain" `
                   -InstallDns:$True `
                   -LogPath "C:\Windows\NTDS" `
                   -NewDomainName "WingtipToys.com" `
                   -NewDomainNetbiosName "WINGTIP" `
                   -ParentDomain "TreyResearch.net"
                   -NoRebootOnCompletion:$False `
                   -SiteName "Default-First-Site-Name" `
                   -SysvolPath "C:\Windows\SYSVOL" `
                   -Force:$True

Get-ADGroupMember -Identity Administrators | ft -auto Name,DistinguishedName

$Nic = Get-NetAdapter -Name Ethernet
$Nic | Set-NetIPInterface -DHCP Disabled 
$Nic | New-NetIPAddress -AddressFamily IPv4 `
                        -IPAddress 192.168.10.210 `
                        -PrefixLength 24 `
                        -Type Unicast `
                        -DefaultGateway 192.168.10.1 
Set-DnsClientServerAddress -InterfaceAlias $Nic.Name `
                           -ServerAddresses 192.168.10.2,2001:db8:0:10::2
$Nic | New-NetIPAddress -AddressFamily IPv6 `
                        -IPAddress 2001:db8:0:10::d2 `
                        -PrefixLength 64 `
                        -Type Unicast `
                        -DefaultGateway 2001:db8:0:10:1


Rename-Computer -NewName tail-dc-210 -Force -Restart

Get-ADTrust -Filter *

Netdom trust /d:engineering.northamerica.treyresearch.net engineering.wingtiptoys.com /add /twoway /Ud:TREYRESEARCH\Charlie /Uo:WINGTIPTOYS\Administrator

$remCred = Get-Credential `
            -Name "TailspinToys\Charlie" `
            -Message "Enter Remote Creds"
$remForest = New-Object `
             System.DirectoryServices.ActiveDirectory.DirectoryContext(`
             'Forest',`
             'TailspinToys.com',`
             $remCred.UserName,`
             $remCred.GetNetworkCredential().Password) 
$locForest=[System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
$locForest.CreateTrustRelationship($remForestObject,'Bidirectional')

