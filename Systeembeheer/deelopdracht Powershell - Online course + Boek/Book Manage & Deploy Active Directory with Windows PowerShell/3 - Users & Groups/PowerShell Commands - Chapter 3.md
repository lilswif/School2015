Get-ADUser -Name Administrator 

$SecurePW = Read-Host -Prompt "Enter a password" -asSecureString
New-ADUser -Name "Charlie Russel" `
           -AccountPassword $SecurePW  `
           -SamAccountName 'Charlie' `
           -DisplayName 'Charlie Russel' `
           -EmailAddress 'Charlie@TreyResearch.net' `
           -Enabled $True `
           -GivenName 'Charlie' `
           -PassThru `
           -PasswordNeverExpires $True `
           -Surname 'Russel' `
           -UserPrincipalName 'Charlie'

$SuperUserGroups = @()  
$SuperUserGroups = (Get-ADUser -Identity "Administrator" -Properties * ).MemberOf

ForEach ($Group in $SuperUserGroups ) {
   Add-ADGroupMember -Identity $Group -Members "Charlie" 
}

(Get-ADUser -Identity Charlie -Properties *).MemberOf

(Get-ADUser -Filter {Enabled -eq "True"} -Properties DisplayName).DisplayName

New-ADGroup –Name 'Accounting Users' `
            -Description 'Security Group for all accounting users' `
            -DisplayName 'Accounting Users' `
            -GroupCategory Security `
            -GroupScope Universal `
            -SAMAccountName 'AccountingUsers' `
            -PassThru

Add-ADGroupMember -Identity AccountingUsers -Members Dave,Stanley -PassThru

Get-ADGroupMember -Identity AccountingUsers

New-ADGroup –Name 'Managers' `
            -Description 'Security Group for all Managers' `
            -DisplayName 'Managers' `
            -GroupCategory Security `
            -GroupScope Universal `
            -SAMAccountName 'Managers' `
            -PassThru 

$ManagerArray = (Get-ADUser -Filter {Description -like "*Manager*" } `
                            -Properties Description).SAMAccountName

Add-ADGroupMember -Identity "Managers" -Members $ManagerArray -PassThru

Get-ADGroupMember -Identity Managers | ft -auto SAMAccountName,Name

Get-ADGroupMember -Identity Managers | ft -auto SAMAccountName,Name,Description

Get-ADGroupMember -Identity Managers | Get-Member

Get-ADGroupMember -Identity Managers `
                   | Get-ADUser -Properties Description `
                   | Format-Table -auto SAMAccountName,Name,Description

$Groups = (Get-ADUser -Identity Charlie -Properties *).MemberOf
Add-ADPrincipalGroupMembership -Identity Alfie -MemberOf $Groups

(Get-ADUser -Identity Alfie -Properties MemberOf).MemberOf

Remove-ADPrincipalGroupMembership -Identity Alfie `
                                  -MemberOf "Enterprise Admins",`
                                            "Schema Admins",`
                                            "Group Policy Creator Owners" `
                                  -PassThru

(Get-ADUser -Identity Alfie -Properties MemberOf).MemberOf

New-ADOrganizationalUnit -Name Engineering `
                         -Description 'Engineering department users and computers' `
                         -DisplayName 'Engineering Department' `
                         -ProtectedFromAccidentalDeletion $True `
                         -Path "DC=TreyResearch,DC=NET" `
                         -PassThru

Get-Command -Module ActiveDirectory -Verb Move | ft -auto CommandType,Name

syntax Move-ADObject

Get-ADUser -Filter {Description -like "*Engineering*" }

Get-ADOrganizationalUnit -Filter {Name -eq "Engineering" }

Get-ADUser -Filter {Description -like "*Engineering*" } | Move-ADObject `
           -TargetPath (Get-ADOrganizationalUnit -Filter {Name -eq "Engineering" }) `
           -WhatIf

Get-ADUser -Filter {Description -like "*Engineering*" } | Move-ADObject `
           -TargetPath (Get-ADOrganizationalUnit -Filter {Name -eq "Engineering" })

Get-ADUser -Identity Harold

Get-ADComputer -Filter {Description -like "*Harold*" }

Move-ADObject -Identity "46df71bd-ba88-4b26-9091-b8db6e07261a" `
              -TargetPath " OU=Engineering,DC=TreyResearch,DC=net" `
              -PassThru

