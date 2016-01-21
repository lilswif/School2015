Import-Module Azure -PassThru

(Get-Command –Module Azure).count

(Get-Command -Module Azure | Select Noun -Unique).count

 Get-Command -Module Azure | Select Noun -Unique 

$ENV:PSModulePath

Import-Module Azure -PassThru

Add-AzureAccount

Get-AzureAccount

Get-AzureSubscription

$myAzSub = (Get-AzureSubscription)[0]

makecert -sky exchange -r -n "CN=MsMVPsCaRoot" -pe -a sha1 -len 2048 -ss My "MsMVPsCaRoot.cer"

dir Cert:\CurrentUser\My

makecert.exe -n "CN=mvps-dc-02" -pe -sky exchange -m 96 -ss My -in "MsMVPsCaRoot" -is my -a sha1

Get-ChildItem Cert:\CurrentUser\My

$myPW = ConvertTo-SecureString -String "P@ssw0rd!" -AsPlainText -Force
Get-ChildItem -Path cert:\CurrentUser\my\C56AAEDE3002259D8BD8D4C67FA111EF853D6DFA `
              | Export-PfxCertificate -FilePath C:\Temp\myPfx.pfx `
                -Password $myPW

Get-AzureVNetConfig -ExportToFile T:\Chapter10\SampleVNetConfig.netcfg

$AzSubs = Get-AzureSubscription
Select-AzureSubscription -SubscriptionName $AzSubs[0].SubscriptionName

$Index = -1
Get-AzureLocation | Format-Table -Auto `
                           @{Label="Count"; `
                             Expression={($Global:Index+=1) } }, `
                           @{Label="Location Name"; `
                             Expression={$_.Name}}


$azLocs = Get-AzureLocation
$azLocs[2]

New-AzureService -ServiceName "msMVPsService" `
                 -Location $azLocs[2].Name `
                 -Label "mvps-ca-cloud-site" `
                 -Description "AD DS Site for msmvps.ca in Azure"

New-AzureStorageAccount -StorageAccountName "mvpvmstorage" -Location $azLocs[2].Name

$subscrNam  = $AzSubs[0].SubscriptionName
$storName = (Get-AzureStorageAccount).StorageAccountName
Set-AzureSubscription -SubscriptionName $subscrNam `
                      -CurrentStorageAccountName $storname

(Get-AzureVMImage).count

$ImgFamily = "Windows Server 2012 R2 Datacenter"
(Get-AzureVMImage | Where {$_.ImageFamily -eq $ImgFamily }).count

$imgFamily = "Windows Server 2012 R2 Datacenter"
$img = Get-AzureVMImage `
          | Where {$_.ImageFamily -eq $imgFamily } `
          | sort PublishedDate -Descending `
          | select -ExpandPropert ImageName -First 1
$img

$vmName = "mvps-adc-03"
$vmSize = "Small"

$mvpsVM1 = New-AzureVMConfig -Name $vmName -InstanceSize $vmSize -ImageName $img
#Local Credentials
$lcred=Get-Credential -Message "Type the name and pwd of the local admin account."

#Domain Credentials
$dcred = Get-Credential -Message "Enter the name and pwd for the Domain Account"
$domDNS = "msmvps.ca"
$domain = "msmvps"
$mvpsVM1 | Add-AzureProvisioningConfig -WindowsDomain `
          -AdminUsername $lcred.GetNetworkCredential().Username `
          -Password $lcred.GetNetworkCredential().Password `
          -Domain $domain `
          -DomainUserName $dcred.GetNetworkCredential().UserName `
          -DomainPassword $dcred.GetNetworkCredential().Password `
          -JoinDomain $domDNS
#Set fixed IP (static DIP)
$mvpsVM1 | Set-AzureStaticVnetIP -IPAddress 10.10.10.3
$mvpsVM1 | Set-AzureSubnet -SubnetNames "Subnet-1"
$mvpSvc = "msMVPsService"
$vnet = "mvps-VirtualNetwork"
New-AzureVM –ServiceName $mvpSvc -VMs $mvpsVM1 -VNetName $vnet
Get-AzureVM -ServiceName $mvpSvc

Get-AzureRemoteDesktopFile -Name mvps-adc-03 `
                           -ServiceName $mvpSvc `
                           -LocalPath c:\temp\mvps-adc-03.rdp

Mstsc c:\temp\mvps-adc-03.rdp

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Update-Help -Force

New-ADReplicationSite -Name Azure-West `
                      -Description "Cloud site in Microsoft Azure"
New-ADReplicationSubnet -Name "10.0.0.0/11" `
                        -Site "Azure-West" `
                        -Location "Microsoft Azure West-US"

Install-ADDSDomainController `
      -NoGlobalCatalog:$false `
      -CreateDnsDelegation:$false `
      -CriticalReplicationOnly:$false `
      -DatabasePath "C:\Windows\NTDS" `
      -DomainName "msmvps.ca" `
      -InstallDns:$true `
      -LogPath "C:\Windows\NTDS" `
      -NoRebootOnCompletion:$false `
      -SiteName "Azure-West" `
      -SysvolPath "C:\Windows\SYSVOL" `
      -Force:$true

