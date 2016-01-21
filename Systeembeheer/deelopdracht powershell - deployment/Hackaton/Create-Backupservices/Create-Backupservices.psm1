
<#
.Synopsis
   Creates a backup server and initiates an initial backup
.DESCRIPTION
   A new resource group will be created to which a backup vault will be assigned. 
   To this backupvault we will assign the desired Azure VirtualMachine. 
   Following we configure a daily backupschedule and enable backup protection.
   Lastly we create the job to create an initial backup right now.
   These settings can afterwards be changed in the management portal.
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.Notes
Author: Matthias
#>
function Create-Backupservices
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true)]
        [string]$ResourceGroup,

        [Parameter(Mandatory=$true)]
        [string]$VirtualMachineName,

        # Param2 help description
        [Parameter(Mandatory=$true)]
        [string]$serviceName,
        # Param2 help description
        [Parameter(Mandatory=$true)]
        [string]$Backupname,

        [Parameter(Mandatory=$true)]
        [string]$Location
    )

    Begin
    {
    }
    Process
    {
    #BACKUP
    #Create backupvault
    
    if(!(Get-AzureRMResourceGroup | Where-Object {$_.ResourceGroupName -eq $Resourcegroup})){
    New-AzureRMResourceGroup –Name $ResourceGroup –Location $Location}

    if(!(Get-AzureRmBackupVault | Where-Object {$_.Name -eq $backupvault -and $_.ResourceGroupName -eq $Resourcegroup})){
    New-AzureRMBackupVault –ResourceGroupName $ResourceGroup –Name $Backupname –Region $Location –Storage GeoRedundant}
    
    $backupvault = Get-AzureRmBackupVault -ResourceGroupName $ResourceGroup –Name $Backupname
    Register-AzureRMBackupContainer -Vault $backupvault -Name $VirtualMachineName -ServiceName $serviceName

    #Schedule
    $Daily = New-AzureRMBackupRetentionPolicyObject -DailyRetention -Retention 30
    $newpolicy = New-AzureRMBackupProtectionPolicy -Name DailyBackup01 -Type AzureVM -Daily -BackupTime ([datetime]"3:30 PM") -RetentionPolicy ($Daily) -Vault $backupvault
    #Sleep here is required since the backupcontainter takes a while to register. If you receive an error increase the sleep time.
    sleep(30)
    Get-AzureRMBackupContainer -Type AzureVM -Status Registered -Vault $backupvault | Get-AzureRMBackupItem| Enable-AzureRMBackupProtection -Policy $newpolicy

    #Backup now
    $container = Get-AzureRMBackupContainer -Vault $backupvault -type AzureVM -name $VirtualMachineName
    $backupjob = Get-AzureRMBackupItem -Container $container | Backup-AzureRMBackupItem
    $backupjob
    }
    End
    {
    }
}