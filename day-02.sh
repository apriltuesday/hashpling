#!/bin/bash
count1=0
count2=0
while IFS=':' read -r -a line
do
	rule=${line[0]}
	password=${line[1]}

	IFS=' ' read -r -a pieces <<< "$rule"
	c=${pieces[1]}

	IFS='-' read -r -a range <<< "${pieces[0]}"
	lo=${range[0]}
	hi=${range[1]}

	# part 1 check
	occs=0
	while read -n1 curr
	do
		if [[ $curr == $c ]]
		then
			occs=$((occs+1))
		fi
	done <<< $password
	if (($occs >= $lo && $occs <= $hi))
	then
		count1=$((count1+1))
	fi

	# part 2 check
	# lo is ok due to extra space at the front
	if [[ ${password:$lo:1} == $c ]]
	then
		if [[ ${password:$hi:1} != $c ]]
		then
			count2=$((count2+1))
		fi
	elif [[ ${password:$hi:1} == $c ]]
	then
		count2=$((count2+1))
	fi
done

echo "Part 1: $count1"
echo "Part 2: $count2"
