# -----------------------------------------------------------------------------
# Script: mandatoryParameter.ps1
# Author: ed wilson, msft
# Date: 04/22/2012 16:32:01
# Keywords: Scripting Techniques, Error Handling
# comments: Make the Parameter mandatory
# PowerShell 3.0 Step-by-Step, Microsoft Press, 2012
# Chapter 19
# -----------------------------------------------------------------------------
#Requires –version 3.0
Param(
   [Parameter(Mandatory=$true)]
   [string]$drive,
   [string]$computerName = $env:computerName
) #end param

Function Get-DiskInformation($computerName,$drive)
{
 Get-WmiObject -class Win32_volume -computername $computername `
-filter "DriveLetter = '$drive'"
} #end function Get-BiosName

# *** Entry Point To Script ***

 Get-DiskInformation -computername $computerName -drive $drive
