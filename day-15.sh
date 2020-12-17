#!/usr/local/bin/bash

# input=(0 3 6)  # test input
input=(14 3 1 0 9 5)  # real input
n=${#input[@]}

declare -A last_spoken
for (( i=0; i<2020; i++ ))
do
	turn=$((i+1))
	if [[ $i -lt $n ]]
	then
		curr=${input[$i]}
		last_spoken[$curr]=$turn
		continue
	fi
	last=${last_spoken[$curr]}
	if [[ -z $last ]]
	then
		next=0
	else
		next=$((i-last))
	fi
	last_spoken[$curr]=$i
	curr=$next
done

echo "$curr"
