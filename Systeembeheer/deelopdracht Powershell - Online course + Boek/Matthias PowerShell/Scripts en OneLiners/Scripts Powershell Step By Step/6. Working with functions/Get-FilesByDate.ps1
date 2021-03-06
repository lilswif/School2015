# -----------------------------------------------------------------------------
# Script: Get-FilesByDate.ps1
# Author: ed wilson, msft
# Date: 05/28/2012 16:07:04
# Keywords: 
# comments: 
#
# -----------------------------------------------------------------------------
Function Get-FilesByDate
{
 Param(
  [string[]]$fileTypes,
  [int]$month,
  [int]$year,
  [string[]]$path)
   Get-ChildItem -Path $path -Include $filetypes -Recurse |
   Where-Object { 
   $_.lastwritetime.month -eq $month -AND $_.lastwritetime.year -eq $year }
  } #end function Get-FilesByDate