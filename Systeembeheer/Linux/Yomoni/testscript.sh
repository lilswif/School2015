#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir -p "$DIR"/tmp
chmod -R 755 "$DIR"/tmp

b=HALLO
VAR=WERELD
c=ALLES
d=GOED?


sudo tee "$DIR"/tmp/test-$b.txt > /dev/null << EOF
    <th> $b </th> 
    <td> $VAR </td>
EOF


sudo tee -a "$DIR"/tmp/test-$b.txt > /dev/null << EOF
    <th> $c </th> 
    <td> $d </td>
EOF