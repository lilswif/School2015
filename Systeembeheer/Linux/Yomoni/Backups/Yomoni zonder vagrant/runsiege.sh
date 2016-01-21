#!/bin/bash

function echocolor() { # $1 = string
COLOR='\033[1;33m'
NC='\033[0m'
printf "${COLOR}$1${NC}\n"
}

echocolor "**************************************************************************"
echocolor "**                     SIEGE GRAPH GENERATOR                            **"
echocolor "**************************************************************************"
echo 
echo 
echocolor "**************************************************************************"
echocolor "**                          INITIALISATION                              **"
echocolor "**************************************************************************"


set -o errexit # abort on nonzero exitstatus
set - nounset #abort on unbound variable

##haal locatie van script op 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir -p "$DIR"/tmp

#laad config's
source config.cfg

if [ "$RANGE" = "TRUE" ]; then     
    CONCUSERS=()  

    for (( K="$START"; K<="$STOP"; K=K+"$JUMP" ))
      do
        CONCUSERS+=("$K")
      done  
fi


TELLER=0

for p in "${CONCUSERS[@]}"
do
    TELLER=$(( TELLER+1 ))
done


TOTALNRTESTS=$((TELLER*NUMBEROFTESTS))

echocolor "Name of the link for the HTML-page"
read lognaam
echo

echocolor "**************************************************************************"
echocolor "**                          CHECK TO CONTINUE                           **"
echocolor "**************************************************************************"
echo
echo "  "Numbers of concurring users "("Total: "$TELLER"")": 
for a in $"${CONCUSERS[@]}"
do
 echo -n "$a " 
done
echo 
echo

cat << _EOF_
  Time each concurring user will be tested = "$NUMBEROFTESTS" 
  Total tests run = "$TOTALNRTESTS" 
  Time for a single test = "$TIME"
  Siege delay on each test = "$DELAY"
_EOF_

echo
echocolor "continue? (type y / n)"
read checkers

if [ "$checkers" = "n" ]; then     
    exit    
fi

echo 
echocolor "**************************************************************************"
echocolor "**             TIME TO ENGAGE, LAY BACK, WATCH, RELAX!                  **"
echocolor "**************************************************************************"
echo

for b in "${CONCUSERS[@]}"
do

echo 
echocolor "**************************************************************************"
echocolor "**        STARTING $NUMBEROFTESTS ATTACKS WITH $b USERS                           **"
echocolor "**************************************************************************"
echo 	

COUNTER=0
while [  $COUNTER -lt "$NUMBEROFTESTS" ]; do
    /usr/local/bin/siege -c "$b" -d "$DELAY" -t "$TIME"
    let COUNTER=COUNTER+1 
done

echo 
echocolor "**************************************************************************"
echocolor "**               ATTACKS FINISHED: MAKING TABLE ROW                     **"
echocolor "**************************************************************************"
echo 	

#Copy log file & clear it
cp -r /usr/local/var/siege.log "$DIR"/tmp/"$lognaam".csv
sudo bash -c 'echo "" > /usr/local/var/siege.log'

COUNTER=2
mkdir -p "$DIR"/tmp
chmod -R 775 "$DIR"/tmp

while [  $COUNTER -lt 11 ]; do
	
	if [ $COUNTER = 2 ]; 
        then

VAR=`cat $DIR/tmp/$lognaam.csv  | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$NUMBEROFTESTS"'" }'`
#resulttable            
sudo tee "$DIR"/tmp/"$lognaam"-"$b".txt > /dev/null << EOF
    <th> $b </th> 
    <td> $VAR </td>
EOF

#transtable
VAR=`cat $DIR/tmp/"$lognaam".csv  | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$NUMBEROFTESTS"'" }'`
sudo tee "$DIR"/tmp/trans-"$b".txt > /dev/null << EOF
    <th> $b </th> 
    <td> $VAR </td>
EOF

        elif [ $COUNTER -eq 3 ] || [ $COUNTER -eq 6 ] 
            then

VAR=`cat $DIR/tmp/$lognaam.csv | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$NUMBEROFTESTS"'" }'`

#resulttable            
sudo tee -a "$DIR"/tmp/"$lognaam"-"$b".txt > /dev/null << EOF
    <td> $VAR </td>
EOF

        elif [ $COUNTER -eq 9 ]
            then

VAR=`cat $DIR/tmp/$lognaam.csv | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$NUMBEROFTESTS"'" }'`            
#resultstable
sudo tee -a "$DIR"/tmp/"$lognaam"-"$b".txt > /dev/null << EOF
    <td> $VAR </td>
EOF

#transtable
VAR=`cat $DIR/tmp/$lognaam.csv | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$NUMBEROFTESTS"'" }'`
sudo tee -a "$DIR"/tmp/trans-"$b".txt > /dev/null << EOF
    <td> $VAR </td>
EOF

        elif [ $COUNTER -eq 10 ] 
            then

#resultstable
VAR=`cat $DIR/tmp/$lognaam.csv | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$NUMBEROFTESTS"'" }'`
sudo tee  -a "$DIR"/tmp/"$lognaam"-"$b".txt > /dev/null << EOF
    <td> $VAR </td>
EOF

#transtable
VAR=`cat $DIR/tmp/$lognaam.csv | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$NUMBEROFTESTS"'" }'`
sudo tee -a "$DIR"/tmp/trans-"$b".txt > /dev/null << EOF
    <td> $VAR </td>
EOF

        elif [ $COUNTER -eq 5 ]; 
            then
VAR=`cat $DIR/tmp/$lognaam.csv  | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$NUMBEROFTESTS"'" }'`

            if [ "$VAR" != "$DIR/tmp/$lognaam.csv nan" ]
                then

sudo tee -a "$DIR"/tmp/"$lognaam"-"$b".txt > /dev/null << EOF
    <td> $VAR </td>
EOF
            
            else

sudo tee -a "$DIR"/tmp/"$lognaam"-"$b".txt > /dev/null << EOF
    <td> 0 </td>
EOF

            fi
        fi

        let COUNTER=COUNTER+1 
    done
done

FAI=$(awk -F',' '{sum+=$10; ++n} END { print sum }' "$DIR/tmp/$lognaam.csv")
SUC=$(awk -F',' '{sum+=$9; ++n} END { print sum }' "$DIR/tmp/$lognaam.csv")


echo 
echocolor "**************************************************************************"
echocolor "**            TEST RUN FINISHED: MAKING GLOBAL OVERVIEW                 **"
echocolor "**************************************************************************"
echo 

sudo tee "$DIR"/tmp/tmptabel.txt > /dev/null << EOF
        <div class='pure-g'>
        <div class='pure-u-1-2'>
             <table class='pure-table pure-table-horizontal'>
             <tbody>
               <tr><td> Total tests ran </td><td>-</td><td> $TOTALNRTESTS </td></tr>
               <tr><Td> Tests ran for each concurring user </td><td>-</td><td> $NUMBEROFTESTS </td></Th>
               <tr><td> time for each test</td><td>-</td><td> $TIME </td></tr>
               <tr><td> delay </td><td>-</td><td> $DELAY </td></tr>
           </tbody>
           </table>
           
           </div>
           <div class='pure-u-1-2'>
           <table style='display: none;' id='failorsuc'>
           <thead>
           <th> succesfull </th> <th> failure </th>
   </thead>
   <tbody>
       <tr>
           <th>Succesfull</th>
           <td>$SUC</td>
        </tr><tr>
         <th>failures</th>
           <td>$FAI</td>
       </tr>
   </tbody>
   </table>
           <div id='failsucces' style='min-width: 310px; height: 200px; max-width: 500px; margin: 0 auto'></div>

           </div>
           </div>        
           <h2 class='content-subhead'>ResultatenTabel</h2>
           <p>
               Elke waarde is het gemiddelde.
           </p>
EOF


echo 
echocolor "**************************************************************************"
echocolor "**                        MAKING RESULTS TABLE                          **"
echocolor "**************************************************************************"
echo 


sudo tee -a "$DIR"/tmp/tmptabel.txt > /dev/null << EOF
<table id='datatable' class='pure-table pure-table-horizontal'>
 <thead>
  <tr>
   <th> Conc. users </th>
   <th> Transactions </th>
   <th> Elapsed Time </th>
   <th> Response Time </th>
   <th> Transaction Rate </th>
   <th> Succesful Transactions </th>
   <th> Failed Transactions </th>
  </tr>
 </thead>
 <tbody>
EOF

for c in "${CONCUSERS[@]}"
do 
sudo bash -c 'echo "<tr>" >> '"$DIR"'/tmp/tmptabel.txt'
sudo bash -c 'cat '"$DIR"'/tmp/'"$lognaam"'-'"$c"'.txt >> '"$DIR"'/tmp/tmptabel.txt'
sudo bash -c 'echo "</tr>" >> '"$DIR"'/tmp/tmptabel.txt'
done

sudo tee -a "$DIR"/tmp/tmptabel.txt > /dev/null << EOF
</tbody>
</table>

<table style='display: none;' id='transdata'>
    <thead>
        <tr>
            <th> Conc. users </th>
            <th> Transactions </th>
            <th> Succesful Transactions </th>
            <th> Failed Transactions </th>
        </tr>
    </thead>
    <tbody>
EOF

for d in "${CONCUSERS[@]}"
do 
sudo bash -c 'echo "<tr>" >> '"$DIR"'/tmp/tmptabel.txt'
sudo bash -c 'cat '"$DIR"'/tmp/trans-'"$d"'.txt >> '"$DIR"'/tmp/tmptabel.txt'
sudo bash -c 'echo "</tr>" >> '"$DIR"'/tmp/tmptabel.txt'
done
echo "</tbody></table>" >> "$DIR"/tmp/tmptabel.txt

echo 
echocolor "**************************************************************************"
echocolor "**                        BUILDING HTML PAGE                            **"
echocolor "**************************************************************************"
echo 

cp -r "$DIR"/Website/template/boven.html "$DIR"/Website/pages/"$lognaam".html  
cat "$DIR"/tmp/tmptabel.txt >> "$DIR"/Website/pages/"$lognaam".html  
cat "$DIR"/Website/template/onder.html >> "$DIR"/Website/pages/"$lognaam".html  

echo "<li class='pure-menu-item'><a href='pages/$lognaam.html' class='pure-menu-link'>$lognaam</a></li>" >> "$DIR"/Website/menu-i.html 
echo "<li class='pure-menu-item'><a href='$lognaam.html' class='pure-menu-link'>$lognaam</a></li>" >> "$DIR"/Website/menu-t.html 

echo 
echocolor "**************************************************************************"
echocolor "**                        ClEANING UP                                   **"
echocolor "**************************************************************************"
echo 

rm -r "$DIR"/tmp

echo 
echocolor "**************************************************************************"
echocolor "**                         DONE, HOORAY                                 **"
echocolor "**************************************************************************"
echo 