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
echo
echocolor "on wich numbers of concurring users you want to test (seperate with a space): "
read -a arr
echo 
echocolor "how many times would you like to run a single test (for each number of conurring users): "
read AANTALXTEST
echo
echocolor "How long you want a single test to run? (format: Number + S/M/H/D)"
read Twaarde
echo
echocolor "Delay-value?: "
read Dwaarde
echo
echocolor "Name of the link for the HTML-page"
read lognaam
echo
echocolor "**************************************************************************"
echocolor "**                          CHECK TO CONTINUE                           **"
echocolor "**************************************************************************"
echo 
echocolor "check site for following concurring users:"
for a in ${arr[@]}
do 
echo -n $a " "
done
echo
echo
echocolor "Time for a single test = " 
echo -n $Twaarde
echo
echo
echocolor "Delay Time = " 
echo -n $Dwaarde
echo
echo
echocolor "continue? (type y / n)"
read checkers
if [ $checkers = "n" ]; then     
    exit    
fi

echo 
echocolor "**************************************************************************"
echocolor "**             TIME TO ENGAGE, LAY BACK, WATCH, RELAX!                  **"
echocolor "**************************************************************************"
echo
for b in ${arr[@]}
do 
echo 
echocolor "**************************************************************************"
echocolor "**        STARTING "$AANTALXTEST" ATTACKS WITH "$b" USERS               **"
echocolor "**************************************************************************"
echo 	

COUNTER=0
while [  $COUNTER -lt $AANTALXTEST ]; do
    siege -c $b -d $Dwaarde -t $Twaarde
    let COUNTER=COUNTER+1 
done

echo 
echocolor "**************************************************************************"
echocolor "**               ATTACKS FINISHED: MAKING TABLE ROW                     **"
echocolor "**************************************************************************"
echo 	
cp -r /usr/local/var/siege.log /home/fred/SiegeCSV/$lognaam.CSV
sudo bash -c 'echo "" > /usr/local/var/siege.log'

#1) timestamp
#2) transactions
#3) elapsed time
#4) data transfered
#5) response time
#6) transaction rate
#7) troughput
#8) concurrency
#9) Succesfull
#10) failed
# 4 - 7 -8
COUNTER=2
while [  $COUNTER -lt 11 ]; do
	
	if [ $COUNTER = 2 ]; 
        then
            #voor resultstable
            sudo bash -c 'echo -n "<th>" '$b' "</th>" > /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
            sudo bash -c 'echo -n "<td> " >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
            VAR=`cat /home/fred/SiegeCSV/$lognaam.CSV  | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$AANTALXTEST"'" }'`
            sudo bash -c 'echo -n '$VAR' >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
            sudo bash -c 'echo -n " </td>" >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'

            #voor transactionstable
            sudo bash -c 'echo -n "<th>" '$b' "</th>" > /home/fred/SiegeCSV/trans-'$b'.txt'
            sudo bash -c 'echo -n "<td> " >> /home/fred/SiegeCSV/trans-'$b'.txt'
            VAR=`cat /home/fred/SiegeCSV/$lognaam.CSV  | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$AANTALXTEST"'" }'`
            sudo bash -c 'echo -n '$VAR' >> /home/fred/SiegeCSV/trans-'$b'.txt'
            sudo bash -c 'echo -n " </td>" >> /home/fred/SiegeCSV/trans-'$b'.txt'

        elif [ $COUNTER -eq 3 ] || [ $COUNTER -eq 6 ] 
            then

            sudo bash -c 'echo -n "<td> " >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
            VAR=`cat /home/fred/SiegeCSV/$lognaam.CSV  | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$AANTALXTEST"'" }'`
            sudo bash -c 'echo -n '$VAR' >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
            sudo bash -c 'echo -n " </td>" >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'

        elif [ $COUNTER -eq 9 ]
            then
            #resultstable
            sudo bash -c 'echo -n "<td> " >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
            VAR=`cat /home/fred/SiegeCSV/$lognaam.CSV  | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$AANTALXTEST"'" }'`
            sudo bash -c 'echo -n '$VAR' >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
            sudo bash -c 'echo -n " </td>" >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'

            #transtable
            sudo bash -c 'echo -n "<td> " >> /home/fred/SiegeCSV/trans-'$b'.txt'
            VAR=`cat /home/fred/SiegeCSV/$lognaam.CSV  | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$AANTALXTEST"'" }'`
            sudo bash -c 'echo -n '$VAR' >> /home/fred/SiegeCSV/trans-'$b'.txt'
            sudo bash -c 'echo -n " </td>" >> /home/fred/SiegeCSV/trans-'$b'.txt'



        elif [ $COUNTER -eq 10 ] 
            then
            #resultstable
            sudo bash -c 'echo -n "<td> " >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
            VAR=`cat /home/fred/SiegeCSV/$lognaam.CSV  | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$AANTALXTEST"'" }'`
            sudo bash -c 'echo -n '$VAR' >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
            sudo bash -c 'echo -n " </td>" >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'

            #transtable
            sudo bash -c 'echo -n "<td> " >> /home/fred/SiegeCSV/trans-'$b'.txt'
            VAR=`cat /home/fred/SiegeCSV/$lognaam.CSV  | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$AANTALXTEST"'" }'`
            sudo bash -c 'echo -n '$VAR' >> /home/fred/SiegeCSV/trans-'$b'.txt'
            sudo bash -c 'echo -n " </td>" >> /home/fred/SiegeCSV/trans-'$b'.txt'



        elif [ $COUNTER -eq 5 ]; 
            then

            sudo bash -c 'echo -n "<td> " >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
            VAR=`cat /home/fred/SiegeCSV/$lognaam.CSV  | awk -F',' '{sum+=$"'"$COUNTER"'"; ++n} END { print sum/"'"$AANTALXTEST"'" }'`

            if [ $VAR != "nan" ]
                then
                sudo bash -c 'echo -n '$VAR' >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
                sudo bash -c 'echo -n " </td>" >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
            else
                sudo bash -c 'echo -n " 0 </td>" >> /home/fred/SiegeCSV/'$lognaam'-'$b'.txt'
            fi
        fi
        let COUNTER=COUNTER+1 
    done
done

FAI=`cat /home/fred/SiegeCSV/$lognaam.CSV  | awk -F',' '{sum+=$10; ++n} END { print sum }'`
SUC=`cat /home/fred/SiegeCSV/$lognaam.CSV  | awk -F',' '{sum+=$9; ++n} END { print sum }'`


echo 
echocolor "**************************************************************************"
echocolor "**            TEST RUN FINISHED: MAKING GLOBAL OVERVIEW                 **"
echocolor "**************************************************************************"
echo 

echo "         <div class='pure-g'>" > /home/fred/testtabel.txt
echo "          <div class='pure-u-1-2'>" >> /home/fred/testtabel.txt
echo "           <table class='pure-table pure-table-horizontal'>" >> /home/fred/testtabel.txt
echo "           <tbody>" >> /home/fred/testtabel.txt
echo "               <tr><td> Total #tests ran </td><td>-</td><td> "$(($AANTALXTEST * ${#arr[@]}))" </td></tr>" >> /home/fred/testtabel.txt
echo "               <tr><Td> #test ran for each #concurring user </td><td>-</td><td> "$AANTALXTEST" </td></Th>" >> /home/fred/testtabel.txt
echo "               <tr><td> time for each test</td><td>-</td><td> "$Twaarde" </td></tr>" >> /home/fred/testtabel.txt
echo "               <tr><td> delay </td><td>-</td><td> "$Dwaarde" </td></tr>" >> /home/fred/testtabel.txt
echo "           </tbody>" >> /home/fred/testtabel.txt
echo "           </table>" >> /home/fred/testtabel.txt
echo "           " >> /home/fred/testtabel.txt
echo "           </div>" >> /home/fred/testtabel.txt
echo "           <div class='pure-u-1-2'>" >> /home/fred/testtabel.txt
echo "           <table style='display: none;' id='failorsuc'>" >> /home/fred/testtabel.txt
echo "           <thead>" >> /home/fred/testtabel.txt
echo "           <th> succesfull </th> <th> failure </th>" >> /home/fred/testtabel.txt
echo "   </thead>" >> /home/fred/testtabel.txt
echo "   <tbody>" >> /home/fred/testtabel.txt
echo "       <tr>" >> /home/fred/testtabel.txt
echo "           <th>Succesfull</th>" >> /home/fred/testtabel.txt
echo "           <td>"$SUC"</td>" >> /home/fred/testtabel.txt
echo "        </tr><tr>" >> /home/fred/testtabel.txt
echo "         <th>failures</th>" >> /home/fred/testtabel.txt
echo "           <td>"$FAI"</td>" >> /home/fred/testtabel.txt
echo "       </tr>" >> /home/fred/testtabel.txt
echo "   </tbody>" >> /home/fred/testtabel.txt
echo "   </table>" >> /home/fred/testtabel.txt
echo "           <div id='failsucces' style='min-width: 310px; height: 200px; max-width: 500px; margin: 0 auto'></div>" >> /home/fred/testtabel.txt
echo "" >> /home/fred/testtabel.txt
echo "           </div>" >> /home/fred/testtabel.txt
echo "           </div>          " >> /home/fred/testtabel.txt
echo "           <h2 class='content-subhead'>ResultatenTabel</h2>" >> /home/fred/testtabel.txt
echo "           <p>" >> /home/fred/testtabel.txt
echo "               Elke waarde is het gemiddelde." >> /home/fred/testtabel.txt
echo "           </p>" >> /home/fred/testtabel.txt


echo 
echocolor "**************************************************************************"
echocolor "**                        MAKING RESULTS TABLE                          **"
echocolor "**************************************************************************"
echo 


# 1 users | 2 transactions | 3 elapsed time | 4 response time | 5 transaction rate  | 6 Succesfull | 7 failed #
echo "<table id='datatable' class='pure-table pure-table-horizontal'>" >> /home/fred/testtabel.txt
echo " <thead>" >> /home/fred/testtabel.txt
echo "  <tr>" >> /home/fred/testtabel.txt
echo "   <th> #Conc. users </th>" >> /home/fred/testtabel.txt
echo "   <th> #Transactions </th>" >> /home/fred/testtabel.txt
echo "   <th> Elapsed Time </th>" >> /home/fred/testtabel.txt
echo "   <th> Response Time </th>" >> /home/fred/testtabel.txt
echo "   <th> Transaction Rate </th>" >> /home/fred/testtabel.txt
echo "   <th> Succesful Transactions </th>" >> /home/fred/testtabel.txt
echo "   <th> Failed Transactions </th>" >> /home/fred/testtabel.txt
echo "  </tr>" >> /home/fred/testtabel.txt
echo " </thead>" >> /home/fred/testtabel.txt
echo " <tbody>" >> /home/fred/testtabel.txt

for c in ${arr[@]}
do 
sudo bash -c 'echo "<tr>" >> /home/fred/testtabel.txt'
sudo bash -c 'cat /home/fred/SiegeCSV/'$lognaam'-'$c'.txt >> /home/fred/testtabel.txt'
sudo bash -c 'echo "</tr>" >> /home/fred/testtabel.txt'
rm -f /home/fred/SiegeCSV/$lognaam-$c.txt
done
echo "</tbody></table>" >> /home/fred/testtabel.txt

#Transdata
echo "<table style='display: none;' id='transdata'><thead><tr><th> #Conc. users </th><th> #Transactions </th><th> Succesful Transactions </th><th> Failed Transactions </th></thead><tbody>" >> /home/fred/testtabel.txt 
for d in ${arr[@]}
do 
sudo bash -c 'echo "<tr>" >> /home/fred/testtabel.txt'
sudo bash -c 'cat /home/fred/SiegeCSV/trans-'$d'.txt >> /home/fred/testtabel.txt'
sudo bash -c 'echo "</tr>" >> /home/fred/testtabel.txt'
rm -f /home/fred/SiegeCSV/trans-$d.txt
done
echo "</tbody></table>" >> /home/fred/testtabel.txt

rm -f /home/fred/SiegeCSV/$lognaam.CSV

echo 
echocolor "**************************************************************************"
echocolor "**                        BUILDING HTML PAGE                            **"
echocolor "**************************************************************************"
echo 

cp -r /home/fred/Githubs/Systeembeheer/Linux/scripts/Website/template/boven.html /home/fred/Githubs/Systeembeheer/Linux/scripts/Website/pages/$lognaam.html  
cat /home/fred/testtabel.txt >> /home/fred/Githubs/Systeembeheer/Linux/scripts/Website/pages/$lognaam.html  
cat /home/fred/Githubs/Systeembeheer/Linux/scripts/Website/template/onder.html >> /home/fred/Githubs/Systeembeheer/Linux/scripts/Website/pages/$lognaam.html  

echo "<li class='pure-menu-item'><a href='pages/"$lognaam".html' class='pure-menu-link'>"$lognaam"</a></li>" >> /home/fred/Githubs/Systeembeheer/Linux/scripts/Website/menu-i.html 
echo "<li class='pure-menu-item'><a href='"$lognaam".html' class='pure-menu-link'>"$lognaam"</a></li>" >> /home/fred/Githubs/Systeembeheer/Linux/scripts/Website/menu-t.html 

echo 
echocolor "**************************************************************************"
echocolor "**                         DONE, HOORAY                                 **"
echocolor "**************************************************************************"
echo 