Add-DnsServerPrimaryZone -Name 'tailspintoys.com' `
                         -ComputerName 'trey-dc-02.treyresearch.net' `
                         -ReplicationScope 'Domain' `
                         -DynamicUpdate 'Secure' `
                         -PassThru

Add-DnsServerPrimaryZone -NetworkID 192.168.10.0/24 `
                         -ReplicationScope 'Forest' `
                         -DynamicUpdate 'NonsecureAndSecure' `
                         -PassThru

Add-DnsServerPrimaryZone -NetworkID 2001:db8:0:10::/64 `
                         -ReplicationScope 'Forest' `
                         -DynamicUpdate 'Secure' `
                         -PassThru

Add-DnsServerPrimaryZone -Name 'tailspintoys.com' `
                         -ZoneFile 'tailspintoys.com.dns' `
                         -DynamicUpdate 'None'

Set-DnsServerPrimaryZone -Name 'TailspinToys.com' `
                         -Notify 'NotifyServers' `
                         -NotifyServers "192.168.10.201","192.168.10.202" `
                         -PassThru

Export-DnsServerZone -Name '0.1.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa' `
                     -Filename '0.1.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa.dns'

Add-DnsServerSecondaryZone –Name 0.1.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa `
                           -ZoneFile "0.1.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa.dns" `
                           -LoadExisting `
                           -MasterServers 192.168.10.2,2001:db8:0:10::2 `
                           -PassThru

Set-DnsServerSecondaryZone -Name 0.1.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa `
                           -MasterServers 192.168.10.3,2001:db8:0:10::3 `
                           -PassThru

Set-DnsServerPrimaryZone -Name 'treyresearch.net' `
                         -SecureSecondaries TransferToZoneNameServer `
                         -PassThru

Add-DnsServerStubZone -Name TailspinToys.com `
                      -MasterServers 192.168.10.4 `
                      -ReplicationScope Domain `
                      -PassThru

Set-DnsServerStubZone -Name TailspinToys.com `
                      -LocalMasters 192.168.10.201,192.168.10.202 `
                      -PassThru

Add-DnsServerConditionalForwarderZone -Name treyresearch.net `
                                      -MasterServers 192.168.10.2,2001:db8::10:2 `
                                      -ForwarderTimeout 5 `
                                      -ReplicationScope "Forest" `
                                      -Recursion $False `
                                      -PassThru

Add-DnsServerConditionalForwarderZone -Name treyresearch.net `
                                      -MasterServers 192.168.10.3,2001:db8::10:3 `
                                      -PassThru

Add-DnsServerZoneDelegation -Name TreyResearch.net `
                            -ChildZoneName Engineering `
                            -IPAddress 192.168.10.12,2001:db8::c `
                            -NameServer trey-engdc-12.engineering.treyresearch.net `
                            -PassThru

 Set-DnsServerZoneDelegation `
             -Name TreyResearch.net `
             -ChildZoneName Engineering `
             -IPAddress 192.168.10.13,2001:db8::d `
             -NameServer trey-engdc-13.engineering.treyresearch.net `
             -PassThru

Get-Help Add-DnsServerResourceRecord* | ft -auto Name,Synopsis

Add-DnsServerResourceRecord  -ZoneName "TreyResearch.net" `
                             -A `
                             -Name trey-wds-11 `
                             -IPv4Address 192.168.10.11 `
                             -CreatePtr `
                             -PassThru

Add-DnsServerResourceRecordA -ZoneName "TreyResearch.net" `
                             -Name trey-wds-11 `
                             -IPv4Address 192.168.10.11 `
                             -CreatePtr `
                             -PassThru

syntax Add-DnsServerResourceRecord

Add-DnsServerResourceRecord  -ZoneName "TreyResearch.net" `
                             -AAAA `
                             -Name trey-wds-11 `
                             -IPv6Address 2001:db8::10:b `
                             -CreatePtr `
                             -PassThru

Add-DnsServerResourceRecord -ZoneName "TreyResearch.net" `
                            -CName `
                            -Name wds `
                            -HostNameAlias trey-wds-11.treyresearch.net `
                            -PassThru

Add-DnsServerResourceRecord -ZoneName "TreyResearch.net" `
                            -Name "."  `
                            -MX `
                            -MailExchange mail.treyresearch.net `
                            -Preference 10

Add-DnsServerResourceRecord -ZoneName "TreyResearch.net" `
                            -Name "."  `
                            -MX `
                            -MailExchange mail2.treyresearch.net `
                            -Preference 20

Add-DnsServerResourceRecord -ZoneName "TreyResearch.net" `
                            -Name _nntp._tcp `
                            -SRV `
                            -DomainName "trey-edge-1.treyresearch.net" `
                            -Port 119 `
                            -Priority 0 `
                            -Weight 0 `
                            -PassThru

Set-DnsServerScavenging -ScavengingState:$True `
                        -ScavengingInterval 4:00:00:00 `
                        -RefreshInterval 3:00:00:00 `
                        -NoRefreshInterval 0 `
                        -ApplyOnAllZones `
                        -PassThru

$NewDNSObj = $OrigDNSObj = Get-DnsServerResourceRecord -Name _nntp._tcp `
                                                       -ZoneName TreyResearch.net `
                                                       -RRType SRV
$NewDNSObj.RecordData.Weight = 20
Set-DnsServerResourceRecord -NewInputObject $NewDNSObj `
                            -OldInputObject $OrigDNSObj `
                            -ZoneName 'treyresearch.net' `
                            -PassThru

Install-WindowsFeature -ComputerName trey-dns-03 `
                       -Name DHCP `
                       -IncludeAllSubFeature `
                       -IncludeManagementTools

#The WinNT in the following IS CASE SENSITIVE
$connection = [ADSI]"WinNT://trey-dns-03" 
$lGroup = $connection.Create("Group","DHCP Administrators")
$lGroup.SetInfo()
$lGroup = $connection.Create("Group","DHCP Users")
$lGroup.SetInfo()


Add-DhcpServerInDC -DnsName 'trey-dns-03' -PassThru

Install-WindowsFeature -Name RSAT-DHCP

Add-DhcpServerv4Scope -Name "Trey-Default" `
                      -ComputerName "trey-dns-03" `
                      -Description "Default IPv4 Scope for Lab" `
                      -StartRange "192.168.10.1" `
                      -EndRange   "192.168.10.200" `
                      -SubNetMask "255.255.255.0" `
                      -State Active `
                      -Type DHCP `
                      -PassThru

Add-DhcpServerv4ExclusionRange -ScopeID "192.168.10.0" `
                               -ComputerName "trey-dns-03" `
                               -StartRange "192.168.10.1" `
                               -EndRange   "192.168.10.20" `
                               -PassThru

Set-DhcpServerv4OptionValue -ScopeID 192.168.10.0 `
                            -ComputerName "trey-dns-03" `
                            -DnsDomain "TreyResearch.net" `
                            -DnsServer "192.168.10.2" `
                            -Router "192.168.10.1" `
                            -PassThru

Add-DhcpServerv6Scope -Name "Trey-IPv6-Default" `
                         -ComputerName "trey-dns-03" `
                         -Description "Default IPv6 Scope for Lab" `
                         -Prefix 2001:db8:0:10:: `
                         -State Active `
                         -PassThru

Add-DhcpServerv6ExclusionRange –ComputerName trey-dns-03 `
                               -Prefix 2001:db8:0:10:: `
                               -StartRange 2001:db8:0:10::1 `
                               -EndRange   2001:db8:0:10::20 `
                               -PassThru

Set-DhcpServerv6OptionValue -Prefix 2001:db8:0:10:: `
                               -ComputerName "trey-dns-03" `
                               -DnsServer 2001:db8:0:10::2 `
                               -DomainSearchList "TreyResearch.net" `
                               -PassThru

