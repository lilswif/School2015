<#
.Synopsis
Get the syntax for a cmdlet or cmdlets
.Description
The Get-Syntax script is a wrapper script to run Get-Command <cmdlet name> -Syntax against one 
or more cmdlets. This allows a quick read on the syntax expected.
.Example
Get-Syntax Get-Help 
Returns the only the syntax for the Get-Help command. 
.Example
Get-Syntax Get-Help,Get-Alias,New-Item
Returns the syntax for each of the specified commands. 
.Parameter cmdlet[]
An array of cmdlets to return the syntax for.  
.Inputs
[string[]]
.Outputs
[string]
.Notes
    Author: Charlie Russel
 Copyright: 2015 by Charlie Russel
          : Permission to use is granted but attribution is appreciated
   Initial: 3/13/2015 (cpr)
   ModHist: 
          :
#>
[CmdletBinding()]
Param(
     [Parameter(Mandatory=$True,Position=0)]
     [string[]]
     $Cmdlet
     )
ForEach ($cmd in $cmdlet) {
   "Syntax for $cmd is:"
   Get-Command $cmd -Syntax 
}
