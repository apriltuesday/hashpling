#!/usr/local/bin/bash
IFS=$'\n' read -d '' -r -a lines
a=0  # accumulator
pc=0  # program counter
visited=()

acc_regex="acc ([+-])([0-9]+)"
jmp_regex="jmp ([+-])([0-9]+)"

while [[ ! " ${visited[@]} " =~ " $pc " ]]
do
	visited+=($pc)
	curr="${lines[$pc]}"
	if [[ $curr =~ $acc_regex ]]
	then
		sign="${BASH_REMATCH[1]}"
		num="${BASH_REMATCH[2]}"
		if [[ "$sign" == "+" ]]
		then
			a=$((a+num))
		else
			a=$((a-num))
		fi
		pc=$((pc+1))
	elif [[ $curr =~ $jmp_regex ]]
	then
		sign="${BASH_REMATCH[1]}"
		num="${BASH_REMATCH[2]}"
		if [[ "$sign" == "+" ]]
		then
			pc=$((pc+num))
		else
			pc=$((pc-num))
		fi
	else
		pc=$((pc+1))
	fi
done

echo "Part 1: $a"

