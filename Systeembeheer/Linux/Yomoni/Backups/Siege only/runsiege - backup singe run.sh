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
#for a in ${arr[@]}
#do 
#  echo $a
#done
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
echocolor "How many concurring Users?"
read Cwaarde
echo
echocolor "Name of the CSV-ouputfile"
read lognaam
echo
echocolor "Clear the original siege-log after test completion? (y / n)"
read clear
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

COUNTER=0
while [  $COUNTER -lt $AANTALXTEST ]; do
siege -c $Cwaarde -d $Dwaarde -t $Twaarde
let COUNTER=COUNTER+1 
 done
echo 
echo
echocolor "***********************"
echocolor "**   DONE ATTACKING  **"
echocolor "***********************"
echo
echo
echocolor "***********************"
echocolor "**MAKING CSV IN HOME **"
echocolor "***********************"
echo
echo Gonna run:
echo cp -r /usr/local/var/siege.log /home/fred/SiegeCSV/$lognaam.CSV
cp -r /usr/local/var/siege.log /home/fred/SiegeCSV/$lognaam.CSV
echo
echo
            if [ $clear = "y" ]; then
            	echo
				echocolor "***********************"
				echocolor "**Clearing log file  **"
				echocolor "***********************"
				echo
            	sudo bash -c 'echo "" > /usr/local/var/siege.log'
            else
                           	echo
				echocolor "*****************************"
				echocolor "**  NOT Clearing log file  **"
				echocolor "*****************************"
				echo
            fi

echocolor "****************************"
echocolor "**  Making Averages table **"
echocolor "****************************"
echo
echo Gonna run:
echo awk '{ total += $2; count++ } END { print total/count }' /home/fred/SiegeCSV/$lognaam.CSV

COUNTER=2
while [  $COUNTER -lt 11 ]; do
	
	if [ $COUNTER = 2 ]; then
			sudo bash -c 'echo -n "<td>" > /home/fred/SiegeCSV/'$lognaam'-averages.txt'
 			VAR=`awk '{ total += $2; count++ } END { print total/count }' /home/fred/SiegeCSV/$lognaam.CSV`
 			sudo bash -c 'echo -n '$VAR' >> /home/fred/SiegeCSV/'$lognaam'-averages.txt'
			sudo bash -c 'echo -n "</td>" >> /home/fred/SiegeCSV/'$lognaam'-averages.txt'
    else
    		sudo bash -c 'echo -n "<td>" >> /home/fred/SiegeCSV/'$lognaam'-averages.txt'
    		VAR=`awk '{ total += $'$COUNTER'; count++ } END { print total/count }' /home/fred/SiegeCSV/$lognaam.CSV`
    		sudo bash -c 'echo -n '$VAR' >> /home/fred/SiegeCSV/'$lognaam'-averages.txt'
			sudo bash -c 'echo -n "</td>" >> /home/fred/SiegeCSV/'$lognaam'-averages.txt'
    fi

let COUNTER=COUNTER+1 
 done

echocolor "***********************"
echocolor "**    DONE, HOORAY!  **"
echocolor "***********************"