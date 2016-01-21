<#
.Synopsis
Get the current Schema version and Forest and Domain Modes
.Description
The Get-myADVersion script queries the AD to discover the current AD schema version, 
and the forest mode and domain mode. If run without parameters, will query the 
current AD context, or if a Domain Controller is specified, it will query against 
that DC's context. Must be run as a user with sufficient privileges to query AD DS.
.Example
Get-myADVersion 
Queries against the current AD context. 
.Example
Get-myADVersion -DomainController Trey-DC-02
Gets the AD versions for the Domain Controller "Trey-DC-02"
.Parameter DomainController
Specifies the domain controller to query. This will change the response to match the AD context of the DC. 
.Inputs
[string]
.Notes
    Author: Charlie Russel
 Copyright: 2015 by Charlie Russel
          : Permission to use is granted but attribution is appreciated
   Initial: 3/7/2015 (cpr)
   ModHist: 
          :
#>
[CmdletBinding()]
Param(
     [Parameter(Mandatory=$False,Position=0)]
     [string]
     $DomainController
     )

if ($DomainController) { 
   $AD = Get-ADRootDSE -Server $DomainController
   Get-ADObject $AD.SchemaNamingContext -Server $DomainController -Property ObjectVersion
} else {
   $AD = Get-ADRootDSE
   Get-ADObject $AD.SchemaNamingContext -Property ObjectVersion
}
$Forest = $AD.ForestFunctionality
$Domain = $AD.DomainFunctionality

# Use a Here-String to print out the result.
$VersionCodes = @"

Forest: $Forest
Domain: $Domain


Where: 
72 = Windows Server Technical Preview Build 9841
69 = Windows Server 2012 R2
56 = Windows Server 2012
47 = Windows Server 2008 R2
44 = Windows Server 2008
31 = Windows Server 2003 R2
30 = Windows Server 2003
13 = Windows 2000
"@

$VersionCodes
