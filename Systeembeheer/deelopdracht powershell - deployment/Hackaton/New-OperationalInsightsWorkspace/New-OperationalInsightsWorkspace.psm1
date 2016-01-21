<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function New-OperationalInsightsWorkspace
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true)]
        [string]$StorageName,
        [Parameter(Mandatory=$true)]
        [string]$Location,
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceName,
        [Parameter(Mandatory=$true)]
        [string]$ServiceName,
        [Parameter(Mandatory=$true)]
        [string]$VirtualMachineName,
        [Parameter(Mandatory=$true)]
        [string]$Resourcegroup
    )

    Begin
    {
    }
    Process
    {
    if(!(Get-AzureRMResourceGroup | Where-Object {$_.ResourceGroupName -eq $Resourcegroup})){
    New-AzureRMResourceGroup –Name $ResourceGroup –Location $Location}

    #Create new OperationalInsightsWorkspace
    New-AzureRmOperationalInsightsWorkspace -ResourceGroupName $Resourcegroup -Name $WorkspaceName -Location $Location

    #Create a storage for the OperationalInsightsWorkspace
    $StorageNameRM = "$StorageName"+"ops"
    New-AzureRmStorageAccount -ResourceGroupName $Resourcegroup -Name $StorageNameRM -type Premium_LRS -Location "East US"

    #Adding the storage
    $Storage = Get-AzureRmStorageAccount –ResourceGroupName $Resourcegroup –Name $StorageNameRM
    $StorageKey = ($Storage | Get-AzureRmStorageAccountKey).Key1
    $ws=Get-AzureRmOperationalInsightsWorkspace -ResourceGroupName $Resourcegroup -Name $WorkspaceName
    New-AzureRmOperationalInsightsStorageInsight –Workspace $ws –Name $StorageNameRM –StorageAccountResourceId $Storage.Id –StorageAccountKey $StorageKey –Tables @("WADWindowsEventLogsTable")

    $workspaceId = (Get-AzureRmOperationalInsightsWorkspace -ResourceGroupName $Resourcegroup -Name $WorkspaceName).CustomerId
    $workspacekey = (Get-AzureRmOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $Resourcegroup -Name $WorkspaceName).PrimarySharedKey
    $vm = Get-AzureVM -ServiceName $ServiceName -Name $VirtualMachineName

    Set-AzureVMExtension -VM $vm -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionName 'MicrosoftMonitoringAgent' -Version '1.*' -PublicConfiguration "{'workspaceId': '$workspaceId'}" -PrivateConfiguration "{'workspaceKey': '$workspaceKey' }" | Update-AzureVM -Verbose


    }
    End
    {
    }
}