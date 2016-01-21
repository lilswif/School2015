$a = 2
Switch ($a)
{
1 { ‘$a = 1’ }
2 { ‘$a = 2’ }
2 { ‘Second match of the $a variable’ }
3 { ‘$a = 3’ }
Default { ‘unable to determine value of $a’ }
}
"Statement after switch"