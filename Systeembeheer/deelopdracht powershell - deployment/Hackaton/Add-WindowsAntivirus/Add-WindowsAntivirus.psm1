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
function Add-WindowsAntivirus
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true)]
        $Servicename,

        # Param2 help description
        [Parameter(Mandatory=$true)]
        $VirtualMachineName,

        [Parameter(Mandatory=$true)]
        $StorageAccountName
    )

    Begin
    {
    }
    Process
    {
    $vm = Get-AzureVM –ServiceName $Servicename –Name $VirtualMachineName
    Set-AzureVMExtension -Publisher Microsoft.Azure.Security -ExtensionName IaaSAntimalware -Version 1.* -VM $vm.VM
    Update-AzureVM -Name $VirtualMachineName -ServiceName $Servicename -VM $vm.VM
    $StorageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey (Get-AzureStorageKey -StorageAccountName $StorageAccountName).Primary
    $AntiMalwareConfig = '{"AntimalwareEnabled" : true}'    Get-AzureVM -ServiceName $Servicename -Name $VirtualMachineName| Set-AzureVMMicrosoftAntimalwareExtension -AntimalwareConfiguration $AntiMalwareConfig -Monitoring ON -StorageContext $StorageContext | Update-AzureVM
    }
    End
    {
    }
}