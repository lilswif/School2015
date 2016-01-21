<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   PS C:\> Enable-AzureDiagnostics -StorageName "g06storage" -ServiceName "G06Service" -VirtualMachineName "G06srv1" -Verbo
se
VERBOSE: 19:32:37 - Begin Operation: Get-AzureStorageKey
VERBOSE: 19:32:39 - Completed Operation: Get-AzureStorageKey
VERBOSE: 19:32:39 - Begin Operation: Get-AzureVMAvailableExtension
VERBOSE: 19:32:42 - Completed Operation: Get-AzureVMAvailableExtension
VERBOSE: 19:32:44 - Completed Operation: Get Deployment
VERBOSE: 19:32:46 - Completed Operation: Get Deployment
VERBOSE: 19:32:46 - Begin Operation: Update-AzureVM

VERBOSE: 19:33:25 - Completed Operation: Update-AzureVM
OperationDescription OperationId                          OperationStatus
-------------------- -----------                          ---------------
Update-AzureVM       a0063817-716c-3f79-986f-036ea48c71df Succeeded

.EXAMPLE
   Another example of how to use this cmdlet
#>
function Enable-AzureDiagnostics
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true)]
        [string]$StorageName,
        [Parameter(Mandatory=$true)]
        [string]$ServiceName,
        [Parameter(Mandatory=$true)]
        [string]$VirtualMachineName
    )

    Begin
    {
    }
    Process
    {
    #Construct Azure Diagnostics public config and convert to config format

    # Collect just system error events:
    $XmlConfiguration = "<WadCfg><DiagnosticMonitorConfiguration><WindowsEventLog scheduledTransferPeriod=""PT1M""><DataSource name=""System!* "" /></WindowsEventLog></DiagnosticMonitorConfiguration></WadCfg>"

    $Base64Config = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($XmlConfiguration))
    $PuclicConfig = [string]::Format("{{""xmlCfg"":""{0}""}}",$Base64Config)

    #Construct Azure diagnostics private config

    $StorageAccountKey = (Get-AzureStorageKey $StorageName).Primary
    $PrivateConfig = [string]::Format("{{""storageAccountName"":""{0}"",""storageAccountKey"":""{1}""}}",$StorageName,$StorageAccountKey)

    #Enable Diagnostics Extension for Virtual Machine

    $ExtensionName = "IaaSDiagnostics"
    $Publisher = "Microsoft.Azure.Diagnostics"
    $Version = (Get-AzureVMAvailableExtension -Publisher $Publisher -ExtensionName $ExtensionName).Version # Gets latest version of the extension

    (Get-AzureVM -ServiceName $ServiceName -Name $VirtualMachineName) | Set-AzureVMExtension -ExtensionName $ExtensionName -Publisher $Publisher -PublicConfiguration $PuclicConfig -PrivateConfiguration $PrivateConfig -Version $Version | Update-AzureVM

    }
    End
    {
    }
}