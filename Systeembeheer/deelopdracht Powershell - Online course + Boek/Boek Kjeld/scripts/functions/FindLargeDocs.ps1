Function Get-Doc($path)
{
Get-ChildItem -Path $path -include *.doc,*.docx,*.dot -recurse
} #end Get-Doc
Filter LargeFiles($size)
{
$_ |
Where-Object { $_.length -ge $size }
} #end LargeFiles
Get-Doc("C:\FSO") | LargeFiles 1000