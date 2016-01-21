Function Get-Discount([double]$rate,[int]$total)
{
$rate * $total
} #end Get-Discount
$rate = .05
$total = 100
$discount = Get-Discount -rate $rate -total $total
"Total: $total"
"Discount: $discount"
"Your Total: $($total-$discount)"