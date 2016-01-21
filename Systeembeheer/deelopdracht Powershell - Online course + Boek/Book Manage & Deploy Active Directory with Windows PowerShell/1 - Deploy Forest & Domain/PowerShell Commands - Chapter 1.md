Get-NetAdapter   

Get-NetAdapter | Get-Member

Set-NetIPInterface -InterfaceAlias "10 Network" -DHCP Disabled -PassThru

New-NetIPAddress `
     -AddressFamily IPv4 `
     -InterfaceAlias "10 Network" ` 
     -IPAddress 192.168.10.2 `
     -PrefixLength 24 `
     -DefaultGateway 192.168.10.1

New-NetIPAddress `
     -AddressFamily IPv6 `
     -InterfaceAlias "10 Network" `
     -IPAddress 2001:db8:0:10::2 `
     -PrefixLength 64 `
     -DefaultGateway 2001:db8:0:10::1

Set-DnsClientServerAddress `
     -InterfaceAlias "10 Network" `
     -ServerAddresses 192.168.10.2,2001:db8:0:10::2

Get-NetIPAddress -InterfaceAlias "10 Network"

Rename-Computer -NewName trey-dc-02 -Restart -Force -PassThru 

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Get-Command -Module ADDSDeployment | Format-Table Name

Update-Help -SourcePath \\trey-dc-02\PSHelp 

Install-ADDSForest `
     -DomainName 'TreyResearch.net' `
     -DomainNetBiosName 'TREYRESEARCH' `
     -DomainMode 6 `
     -ForestMode 6 `
     -NoDnsOnNetwork `
     -SkipPreChecks `
     -Force

$pwdSS = ConvertTo-SecureString -String 'P@ssw0rd!' -AsPlainText -Force



