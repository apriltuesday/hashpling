#!/usr/local/bin/bash
IFS=$'\n' read -d '' -r -a lines
a=0  # accumulator
pc=0  # program counter

acc_regex="acc ([+-])([0-9]+)"
jmp_regex="jmp ([+-])([0-9]+)"

# execute current instruction, advance pc and a accordingly
execute () {
	curr=$1
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
}

# part 1
visited=()
while [[ ! " ${visited[@]} " =~ " $pc " ]]
do
	visited+=($pc)
	execute "${lines[$pc]}"
done

echo "Part 1: $a"

# part 2
n=${#lines[@]}

nop_indices=()
jmp_indices=()

# get indices of nop and jmp instructures
for (( i=0; i<n; i++ ))
do
	curr=${lines[$i]}
	if [[ $curr =~ $acc_regex ]]
	then
		continue
	elif [[ $curr =~ $jmp_regex ]]
	then
		jmp_indices+=($i)
	else
		nop_indices+=($i)
	fi
done

# try replacing either a nop or jmp instruction
replace () {
	if [[ $1 == "nop" ]]
	then
		indices="${nop_indices[@]}"
		s1=nop
		s2=jmp
	else
		indices="${jmp_indices[@]}"
		s1=jmp
		s2=nop
	fi

	for idx in ${indices[@]}
	do
		a=0
		pc=0
		visited=()
		while [[ $pc -lt $n && (! " ${visited[@]} " =~ " $pc ") ]]
		do
			visited+=($pc)
			if [[ $pc -eq $idx ]]
			then
				curr="${lines[$pc]/$s1/$s2}"
			else
				curr="${lines[$pc]}"
			fi
			execute "$curr"
		done
		if [[ $pc -ge $n ]]
		then
			echo "Part 2: $a"
		fi
	done
}

replace nop
replace jmp
