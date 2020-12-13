#!/usr/local/bin/bash
IFS=$'\n' read -d '' -r -a array
n=${#array[@]}

swap () {
	local i=$1
	local j=$2
	tmp="${array[$i]}"
	array[$i]="${array[$j]}"
	array[$j]="$tmp"
}

# sort ascending with insertion sort
i=1
while [[ $i -lt $n ]]
do
	j=$i
	while [[ $j -gt 0 && (${array[$((j-1))]} -gt ${array[$j]}) ]]
	do
		swap $j $((j-1))
		j=$((j-1))
	done
	i=$((i+1))
done

# count 1- and 3-jolt diffs
ones=0
threes=1  # final diff will always be 3

# first diff
if [[ ${array[0]} -eq 1 ]]
then
	ones=$((ones+1))
elif [[ ${array[0]} -eq 3 ]]
then
	threes=$((threes+1))
fi

for (( i=0; i<$((n-1)); i++ ))
do
	v1=${array[$i]}
	v2=${array[$((i+1))]}
	diff=$((v2-v1))

	if [[ $diff -eq 1 ]]
	then
		ones=$((ones+1))
	elif [[ $diff -eq 3 ]]
	then
		threes=$((threes+1))
	fi
done

echo "Part 1: $((ones*threes))"
