#!/usr/local/bin/bash

# part 1
count1 () {
	group=$1
	read -d '' -r -a answers <<< "$(echo $group | grep -o '[^ ]' | sort -u)"
	echo "${#answers[@]}"
}

# part 2
count2 () {
	group=$1
	read -r -a people <<< "$group"
	count=0
	# only need to check first person's answers
	for (( i=0; i<${#people[0]}; i++ ))
	do
		ans=${people[0]:$i:1}
		good=true
		for person in ${people[@]}
		do
			if [[ "$person" != *"$ans"* ]]
			then
				good=false
			fi
		done
		if [[ $good == true ]]
		then
			count=$((count+1))
		fi
	done
	echo $count
}

group=""
sum1=0
sum2=0
while read -r line
do
	if [[ -z "$line" ]]
	then
		# group is done
		n1=$(count1 "$group")
		sum1=$((sum1+n1))
		n2=$(count2 "$group")
		sum2=$((sum2+n2))
		group=""
	else
		group+=" $line"
	fi
done

# count the trailing group
n1=$(count1 "$group")
sum1=$((sum1+n1))
n2=$(count2 "$group")
sum2=$((sum2+n2))

echo "Part 1: $sum1"
echo "Part 2: $sum2"
