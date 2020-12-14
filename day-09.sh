#!/usr/local/bin/bash
preamble_length=$1

i=0
nums=()
while read -r n
do
	if [[ $i -lt $preamble_length ]]
	then
		nums+=($n)
		i=$((i+1))
		continue
	fi

	# past the preamble
	valid=false
	for other in ${nums[@]}
	do
		diff=$((n-other))
		if [[ $diff != $other ]] && [[ " ${nums[@]} " =~ " $diff " ]]
		then
			valid=true
		fi
	done
	if [[ $valid == "false" ]]
	then
		echo "Part 1: $n"
		exit 0
	fi

	nums+=($n)
	nums=(${nums[@]:1})
done
