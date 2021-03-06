# -----------------------------------------------------------------------------
# Script: Get-BiosInformationDefaultParam.ps1
# Author: ed wilson, msft
# Date: 04/22/2012 16:31:07
# Keywords: Scripting Techniques, Error Handling
# comments: 
# PowerShell 3.0 Step-by-Step, Microsoft Press, 2012
# Chapter 19
# -----------------------------------------------------------------------------
Param(
  [string]$computerName = $env:computername
) #end param

Function Get-BiosInformation($computerName)
{
 Get-WmiObject -class Win32_Bios -computername $computername
} #end function Get-BiosName

# *** Entry Point To Script ***

Get-BiosInformation -computerName $computername
