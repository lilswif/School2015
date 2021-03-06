# -----------------------------------------------------------------------------
# Script: DefaultParameterSet.ps1
# Author: ed wilson, msft
# Date: 06/28/2012 14:00:31
# Keywords: Scripting Techniques, Functions, Advanced
# comments: cmdletbinding attribute, defaultparametersetname property
# PowerShell 3.0 Step-by-Step, Microsoft Press, 2012
# Chapter 7
# -----------------------------------------------------------------------------
function Get-ServiceByDisplayOrName
{
[cmdletbinding(DefaultParameterSetName="name")]
param(
  [Parameter(ParameterSetName="name", Position=0)]
  [string]$name,
  [Parameter(ParameterSetName="Display", Position=0)]
  [string]$display)
  if($name)
    { Get-Service -Name $name }
  if($display) 
    { Get-Service -DisplayName $display }
}
