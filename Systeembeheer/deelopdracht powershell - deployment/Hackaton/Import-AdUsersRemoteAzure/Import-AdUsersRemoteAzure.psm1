<#
.Synopsis
Imports users from a CSV file
.Description
We extract the AD user information from the csv and create a new aduser in the more session
.Example


.Parameter Path
The path to the input CSV file. The default value is ".\Documents\AdUsers.csv" .
 
.Notes
    Author: Matthias Derudder
#>

Function Import-AdUsersRemoteAzure{


[CmdletBinding()]
Param(
     [Parameter(Mandatory=$True)]
     [string]$Path,
     [Parameter(Mandatory=$True)]
     [string]$ServiceName,
     [Parameter(Mandatory=$True)]
     [string]$VirtualMachineName,
     [Parameter(Mandatory=$True)]
     [string]$LogPath

     )
     Begin
    {
      $AdminCredentials = Get-Credential
    }
    Process
    {
    # Initialize CSV
    $users
    If (Test-Path $Path ) {
        $users = Import-CSV $Path
    } else { 
        Throw  "This script requires a CSV file with user names and properties."
    }

    # Check logpath
    If (!(Test-Path $LogPath) ) {
        new-item $LogPath -ItemType File  
    }
    $date = get-date
    "-----Following Users have been added on $date-----" | Out-File $LogPath -append

    #Install Certificate for remote connections
    Install-WinRMCertificateForVM -ServiceName $ServiceName -Name $VirtualMachineName

    #Create remote session
    :outer while ($true)
        {
            if ((Get-AzureVM -ServiceName $ServiceName -Name $VirtualMachineName).Status -eq "ReadyRole")
            {
                $Uri = Get-AzureWinRMUri -ServiceName $ServiceName -Name $VirtualMachineName 

                $session = New-PSSession -ConnectionUri $Uri -Credential $AdminCredentials

                break :outer
            }

            "Waiting until the VirtualMachine is Ready"
            sleep (10)
        }

    #Add ad-users on remote session
    :outer while ($true)
        {
            if ((Get-AzureVM -ServiceName $ServiceName -Name $VirtualMachineName).Status -eq "ReadyRole")
            {
                $ScriptBlockContent = {
                 Param($user)
                 $sam = $user.SAMAccountName
                 try{
                       New-AdUser -DisplayName $user.DisplayName `
                                  -Description $user.Description `
                                  -GivenName $user.GivenName `
                                  -Name $user.Name `
                                  -SurName $user.SurName `
                                  -SAMAccountName $user.SAMAccountName `
                                  -EmailAddress $user.Email `
                                  -Enabled $True `
                                  -PasswordNeverExpires $true `
                                  -UserPrincipalName $user.SAMAccountName `
                                  -AccountPassword (ConvertTo-SecureString -AsPlainText -Force -String $user.Password) 

                      Get-ADObject -filter {(ObjectClass -eq "user")} | Where-Object {$_.Name -eq $user.Name} | Set-ADObject -ProtectedFromAccidentalDeletion:$true
                      Write-Host "The user $sam has been successfully added."
                      new-object pscustomobject –property @{
                      logobject = "$sam has been succesfully added"
                      }
                      }
                 Catch{
                      Write-Host "There was an error for $sam. Please consult the log file."
                      new-object pscustomobject –property @{
                      logobject = $Error[0].Exception
                      }
                      }
                    }
                 ForEach ($user in $users ) {

                 $AddUser = Invoke-Command -Session $session -ScriptBlock $ScriptBlockContent -ArgumentList ($user)
                 $sam = $user.SAMAccountName
                 $Logging = $AddUser.logobject
                 "---Following was recorded for $sam---" | Out-File $LogPath -append
                 $Logging | Out-File $LogPath -append
                 
                 }
 
                break :outer
              }
             "Waiting until the VirtualMachine is Ready"
              sleep (10)
                 
            }
            $Error.Exception
            
      }
      End
    {
    
       
        
    }
   }
   

