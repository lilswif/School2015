$ary = 1..5
ForEach($i in $ary)
{
if($i -eq 3) { break }
$i
}
"Statement following foreach loop"