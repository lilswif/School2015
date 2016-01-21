<#
.Synopsis
   Deploys an Azure Virtual machine with AD functions.
.DESCRIPTION
   Very Long description
.EXAMPLE
   PS C:\WINDOWS\system32> Create-AzureVM -CreateStorage $false -StorageName "epichaxzor" -SubscriptionName "Azure Pass" -
ownloadLocation 'D:\Downloads Chrome' -adminUserName "Matthias" -adminPassword "Demo!2015" -VirtualMachineName "g06hack
ton" -Size Small -DomainName "g06hackaton.com" -SubnetNames HackatonSubnet -AffinityGroup Hackaton -VNetName ChronosHac
aton -IP 10.0.0.9
.NOTES
Author: Matthias Derudder
#>
function Create-AzureVM
{
    [CmdletBinding()]
    Param
    (
        # The name that will be given to your storage account
        [Parameter(Mandatory=$true, HelpMessage='What is the storage name?')]
        [String]$StorageName,
        # The name of the subscription you want to use, if you're not sure what your subscription to use consult the portal or run the 'Get-AzureSubscription' cmdlet.
        [Parameter(Mandatory=$true, HelpMessage='What is your subscription name?')]
        [String]$SubscriptionName,
        # The location where your default browser stores its downloads.
        [Parameter(Mandatory=$true, HelpMessage='Where are the downloads from your default browser stored? For example: D:\Downloads')]
        [String]$DownloadLocation,
        # The location where the service will be hosted
        [Parameter(Mandatory=$true, HelpMessage='Specify the location for example: Japan West (hint: use tab)')]
        [ValidateSet('Central US','East US','East US 2','US Gov Iowa','US Gov Virginia','North Central US','South Central US','West US','North Europe','East Asia','Southeast Asia','Japan East','Japan West','Brazil South','Australia East','Australia Southeast','Central India','South India','West India')]
        [String]$Location,
                
        # The built-in administrator account name.
        [Parameter(Mandatory=$true, HelpMessage='Specify the administrators username')]
        [String]$adminUserName,
        # The built-in administrator password.
        [Parameter(Mandatory=$true, HelpMessage='Specify the administrators password')]
        [String]$adminPassword,
        # The name of the virtual machine.
        [Parameter(Mandatory=$true, HelpMessage='Specify the name of the Virtual Machine')]
        [String]$VirtualMachineName,
        # The name of the service on which the virtual machine will run.
        [Parameter(Mandatory=$true, HelpMessage='Specify a new or existing service name')]
        [String]$ServiceName,
        # The size of the machine. The larger you make this, the larger the costs will be. This can be changed later.
        # If you install the extensions you can consult a performance check to see if you should downscale to reduce costs.
        [Parameter(Mandatory=$true, HelpMessage='Specify the size of the Virtual Machine')]
        [ValidateSet('ExtraSmall','Small','Medium','Large','ExtraLarge','A5','A6','A7','A8','A9','Basic_A0','Basic_A1','Basic_A2','Basic_A3','Basic_A4','Standard_D1','Standard_D2','Standard_D3','Standard_D4','Standard_D11','Standard_D12','Standard_D13','Standard_D14')]
        [String]$Size,

        #The name of the domain
        [Parameter(Mandatory=$true, HelpMessage='Specify the name of the Domain. Example: test.com')]
        [ValidatePattern("[a-z0-9]+([\-\.][a-z0-9]+)*\.[a-z]{2,5}$")]
        [String]$DomainName,

        #The name of the subnet
        [Parameter(Mandatory=$true, HelpMessage='Specifies the list of subnet names')]
        [String]$SubnetNames,
        #The affinitygroup in which the cloud service will reside.
        [Parameter(Mandatory=$true, HelpMessage='Specifies the Microsoft Azure affinity group the cloud service will reside in. Only valid when creating a new cloud service.')]
        [String]$AffinityGroup,
        #The name of the virtual network
        [Parameter(Mandatory=$true, HelpMessage='Specifies the virtual network name where the new virtual machine will be deployed.')]
        [String]$VNetName,
        # Specify a static IP 
        [Parameter(Mandatory=$true, HelpMessage='Specify a static VNet IP Address')]
        [ValidatePattern("\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b")]
        [String]$IP,

        #Enables the extensions 
        [Parameter(Mandatory=$false, HelpMessage='Enable Extensions?')]
        [switch]$EnableExentions,
        #The name of the operational insights workspace
        [Parameter(Mandatory=$false, HelpMessage='Specify the name of the Operational Insights')]
        [String]$OperationalInsightsName,
        #The name of the backupvault
        [Parameter(Mandatory=$false, HelpMessage='The name of the backup vault')]
        [String]$BackupVaultName,
        #The name of the resourcegroup
        [Parameter(Mandatory=$false, HelpMessage='Specify the resource group, if you are not sure what to use, use the servicename')]
        [String]$ResourceGroup
    )

    Begin
    {
    }
    Process
    {
    
        If($EnableExentions)
        {
        If(!($OperationalInsightsName))
        {
        echo "Specify OperationalInsightsName"
        break
        }
        If(!($BackupVaultName))
        {
        echo "Specify BackupVaultName"
        break
        }
        If(!($ResourceGroup))
        {
        echo "Specify ResourceGroup"
        break
        }
        #Login to azureRM
        Login-AzureRmAccount
        
        }

        # These variables don't change often hence why they are made static. 
        # When another mayor version releases it's very likely that you'll have to edit these.

        #The windows version from which we'll be taking the most recent version
        [string]$WindowsVersion = “Windows Server 2012 R2 Datacenter”
    
        #Additional Parameters for the AD deployment
        [Array]$NetBiosName = $DomainName.Split(".")
        [string]$NetBiosName = $NetBiosName[0]
        [string]$ForestMode = "Win2012R2"
        [string]$DomainMode = "Win2012R2"
        [string]$databasePath = "C:\Windows\NTDS"
        [string]$logPath = "C:\Windows\NTDS"
        [string]$sysVolPath = "C:\Windows\SYSVOL"

        
        
        #This module needs to be imported
        Acquire-AzurePublishSettingsFile -DownloadLocation $DownloadLocation -SubscriptionName $SubscriptionName

        $CreateStorage = Get-AzureStorageAccount |Where-Object {$_.StorageAccountName -eq $StorageName}
        if($CreateStorage -eq $null){New-AzureStorageAccount -StorageAccountName $StorageName -Location $Location}
        Set-AzureSubscription -SubscriptionName $SubscriptionName -CurrentStorageAccountName $StorageName

        #Creating the VM
        $WindowsImage = Get-AzureVMImage | where { $_.ImageFamily -eq $WindowsVersion } | sort -Property PublishedDate -Descending
        $WindowsImage = $WindowsImage[0].ImageName

        $VirtualMachineCreator = New-AzureVMConfig -Name $VirtualMachineName -InstanceSize $Size -ImageName $WindowsImage `
        | Add-AzureProvisioningConfig -Windows -AdminUsername $adminUserName -Password $adminPassword `
        | Set-AzureSubnet -SubnetNames $SubnetNames | Set-AzureStaticVNetIP -IPAddress $IP  `
        | New-AzureVM -ServiceName $ServiceName -VNetName $VNetName -AffinityGroup $AffinityGroup 

        #Starting the VM
        Start-AzureVM -ServiceName $ServiceName -Name $VirtualMachineName 
        
        #Install the WinRMCertificate this module has to be imported. If you dont know how read the manual.
        Install-WinRMCertificateForVM -ServiceName $ServiceName -Name $VirtualMachineName


        #Preparing the remote session to the VM
        :outer while ($true)
        {
            if ((Get-AzureVM -ServiceName $ServiceName -Name $VirtualMachineName).Status -eq "ReadyRole")
            {
                $Uri = Get-AzureWinRMUri -ServiceName $ServiceName -Name $VirtualMachineName 

                $SecurePassword = ConvertTo-SecureString $adminPassword -AsPlainText -Force
                $AdminCredentials = New-Object System.Management.Automation.PSCredential($adminUserName, $SecurePassword)

                $session = New-PSSession -ConnectionUri $Uri -Credential $AdminCredentials

                break :outer
            }

            "Waiting until the VirtualMachine is Ready"
            sleep (10)
        }



        # Configure Domain 
        :outer while ($true)
        {
            if ((Get-AzureVM -ServiceName $ServiceName -Name $VirtualMachineName).Status -eq "ReadyRole")
            {
            $ScriptBlockContent = {
            Param($DatabasePath,$DomainName,$NetBiosName,$DomainMode,$ForestMode,$LogPath,$SysVolPath,$SecurePassword)

                # Install domain services 
                Install-WindowsFeature AD-Domain-Services -IncludeManagementTools


                # Create New Forest, add Domain Controller 
                Import-Module ADDSDeployment

                #Domain

                Install-ADDSForest `
                -InstallDns `
                -DatabasePath $DatabasePath `
                -DomainName $DomainName `
                -DomainNetbiosName $NetBiosName `
                -DomainMode $DomainMode `
                -ForestMode $ForestMode `
                -LogPath $LogPath `
                -SysvolPath $SysVolPath `
                -Safemodeadministratorpassword ($SecurePassword) `
                -Force

               }
                Invoke-Command -Session $session -ScriptBlock $ScriptBlockContent -ArgumentList ($DatabasePath,$DomainName,$NetBiosName,$DomainMode,$ForestMode,$LogPath,$SysVolPath,$SecurePassword)

                break :outer

            

            
            }
            "Waiting until the VirtualMachine is Ready"
            sleep (20)
        }
     :outer while ($true)
       {
        If($EnableExentions)
        {
        New-OperationalInsightsWorkspace -StorageName $StorageName -Location $Location -WorkspaceName $OperationalInsightsName -ServiceName $ServiceName -VirtualMachineName $VirtualMachineName -Resourcegroup $ResourceGroup
        Enable-AzureDiagnostics -StorageName $StorageName -ServiceName $ServiceName -VirtualMachineName $VirtualMachineName
        Add-WindowsAntivirus -Servicename $ServiceName -VirtualMachineName $VirtualMachineName -StorageAccountName $StorageName
        Create-Backupservices -ResourceGroup $ResourceGroup -VirtualMachineName $VirtualMachineName -serviceName $ServiceName -Backupname $BackupVaultName -Location $Location

        break :outer
        }
        "Waiting until the VirtualMachine is Ready"
            sleep (20)
       }

    }
    End
    {
    }
}