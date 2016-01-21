# -----------------------------------------------------------------------------
# Script: PinToStartAndTaskBar.ps1
# Author: ed wilson, msft
# Date: 04/22/2012 22:05:55
# Keywords: Accessing Windows PowerShell
# comments: This works for Engish only. To use in other cultures, change the
# values of $pinToStart and $pinToTaskBar.
# PowerShell 3.0 Step-by-Step, Microsoft Press, 2012
# Chapter 1
# -----------------------------------------------------------------------------
$pinToStart = "Pin to Start"
$pinToTaskBar = "Pin to Taskbar"
$file = @((join-path -Path $PSHOME  -childpath "PowerShell.exe"),
          (join-path -Path $PSHOME  -childpath "powershell_ise.exe") )
Foreach($f in $file)
 {$path = Split-Path $f
  $shell=new-object -com "Shell.Application" 
  $folder=$shell.Namespace($path)   
  $item = $folder.parsename((split-path $f -leaf))
  $verbs = $item.verbs()
  foreach($v in $verbs)
    {if($v.Name.Replace("&","") -match $pinToStart){$v.DoIt()}}
  foreach($v in $verbs)
    {if($v.Name.Replace("&","") -match $pinToTaskBar){$v.DoIt()}} }