Function Get-TextStatistics($path)
{
Get-Content -path $path |
Measure-Object -line -character -word
Write-Path
}
Function Write-Path()
{
"Inside Write-Path the `$path variable is equal to $path"
}
Get-TextStatistics("C:\fso\test.txt")
"Outside the Get-TextStatistics function `$path is equal to $path"