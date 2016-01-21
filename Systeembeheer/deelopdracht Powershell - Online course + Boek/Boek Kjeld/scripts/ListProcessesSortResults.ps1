<#The ListProcessesSortResults.ps1 script is a script that a network administrator might want
to schedule to run several times a day. It produces a list of currently running processes and
writes the results to a text file as a formatted and sorted table #>

$args = "localhost","loopback","127.0.0.1"
foreach ($i in $args)
{$strFile = "c:\mytest\"+ $i +"Processes.txt"
Write-Host "Testing" $i "please wait ...";
Get-WmiObject -computername $i -class win32_process |
Select-Object name, processID, Priority, ThreadCount, PageFaults, PageFileUsage |
Where-Object {!$_.processID -eq 0} | Sort-Object -property name |
Format-Table | Out-File $strFile}