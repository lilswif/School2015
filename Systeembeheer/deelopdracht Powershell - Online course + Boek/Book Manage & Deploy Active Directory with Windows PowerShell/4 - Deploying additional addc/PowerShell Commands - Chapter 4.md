Get-NetAdapter 

$Nic = Get-NetAdapter -Name Ethernet

$Nic | Set-NetIPInterface -DHCP Disabled

$Nic | New-NetIPAddress -AddressFamily IPv4 `
                         -IPAddress 192.168.10.9 `
                         -PrefixLength 24 `
                         -type Unicast `
                         -DefaultGateway 192.168.10.1

Set-DnsClientServerAddress -InterfaceAlias $Nic.Name `
                           -ServerAddresses 192.168.10.2,2001:db8:0:10::2 `
                           -PassThru

$NIC |  New-NetIPAddress -AddressFamily IPv6 `
                         -IPAddress 2001:db8:0:10::9 `
                         -PrefixLength 64 `
                         -type Unicast `
                         -DefaultGateway 2001:db8:0:10::1

ipconfig

Get-WindowsFeature `
            | Where-Object {$_.DisplayName -match "Active" `
                       -AND $_.InstallState -eq "Available" } `
            | Format-Table -auto DisplayName,Name,InstallState

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Update-Help -SourcePath \\cpr-labhost-6\pshelp -force

$domCred  = Get-Credential -UserName "TreyResearch\Charlie" `
                           -Message "Enter the Domain  password for Charlie."
Add-Computer -DomainName "TreyResearch.net" `
             -Credential $domCred `
             -NewName trey-dc-04 

Test-ADDSDomainControllerInstallation `
      -NoGlobalCatalog:$false `
      -CreateDnsDelegation:$false `
      -CriticalReplicationOnly:$false `
      -DatabasePath "C:\Windows\NTDS" `
      -DomainName "TreyResearch.net" `
      -LogPath "C:\Windows\NTDS" `
      -NoRebootOnCompletion:$false `
      -SiteName "Default-First-Site-Name" `
      -SysvolPath "C:\Windows\SYSVOL" `
      -InstallDns:$true `
      -Force

Install-ADDSDomainController `
      -SkipPreChecks `
      -NoGlobalCatalog:$false `
      -CreateDnsDelegation:$false `
      -CriticalReplicationOnly:$false `
      -DatabasePath "C:\Windows\NTDS" `
      -DomainName "TreyResearch.net" `
      -InstallDns:$true `
      -LogPath "C:\Windows\NTDS" `
      -NoRebootOnCompletion:$false `
      -SiteName "Default-First-Site-Name" `
      -SysvolPath "C:\Windows\SYSVOL" `
      -Force:$true

Add-ADGroupMember -Identity "Cloneable Domain Controllers" `
                  -Members (Get-ADComputer -Identity trey-dc-04).SAMAccountName `
                  -PassThru

Remove-ADGroupMember -Identity "Cloneable Domain Controllers" `
                     -Members (Get-ADComputer -Identity trey-dc-04).SAMAccountName `
                     -PassThru

Get-ADDCCloningExcludedApplicationList

Uninstall-WindowsFeature -Name Windows-Defender

Restart-Computer -Wait 0

Get-ADDCCloningExcludedApplicationList -GenerateXML

Get-ADComputer -Identity trey-dc-04 | Get-ADComputerServiceAccount

New-ADDCCloneConfigFile -Static `
                        -CloneComputerName trey-dc-10 `
                        -IPv4Address 192.168.10.10 `
                        -IPv4SubnetMask 255.255.255.0 `
                        -IPv4DefaultGateway 192.168.10.1 `
                        -IPv4DNSResolver 192.168.10.2

Copy-Item "D:\VMs\trey-dc-04\Virtual Hard Disks\trey-dc-04-system.vhdx" `
           "V:\trey-dc-10\Virtual Hard Disks\trey-dc-10-system.vhdx"
$ClonedDC=New-VM -Name trey-dc-10 `
           -MemoryStartupBytes 1024MB `
           -Generation 2 `
           -BootDevice VHD `
           -Path "V:\" `
           -VHDPath "V:\trey-dc-10\Virtual Hard Disks\trey-dc-10-system.vhdx" `
           -Switch "Local-10"
Set-VM -VM $ClonedDC -ProcessorCount 2 -DynamicMemory -PassThru 
Start-VM $ClonedDC

Get-ADDomain -Identity treyresearch.net

Move-ADDirectoryServerOperationMasterRole `
                         -OperationMaster PDCEmulator,RIDMaster,InfrastructureMaster `
                         -Identity trey-dc-04

Move-ADDirectoryServerOperationMasterRole `
                         -Identity 'trey-dc-09' `
                         -OperationMasterRole SchemaMaster,DomainNamingMaster

Move-ADDirectoryServerOperationMasterRole `
                    -OperationMaster PDCEmulator,RIDMaster,InfrastructureMaster `
                    -Identity trey-dc-02 `
                    -Force

Remove-VM -Name trey-dc-04 ; rm -r D:\VMs\trey-dc-04

