#The DirectoryListWithArguments.ps1 script takes a single, unnamed argument that allows
#the script to be modified when it is run. This makes the script much easier to work with and
#adds flexibility.

foreach ($i in $args)
    {Get-ChildItem $i | Where-Object length -gt 1000 |
    Sort-Object -property name}