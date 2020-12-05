#!/usr/local/bin/bash

# part 1
check1 () {
	passport=$1
	fields=(byr iyr eyr hgt hcl ecl pid)
	for field in ${fields[@]}
	do
		if [[ "$passport" != *"$field"* ]]
		then
			echo "false"
			return
		fi
	done
	echo "true"
}

# part 2
check2 () {
	passport=$1

	# search for the appropriate string for each field
	# value will be nonempty only when field not valid
	byr=$(echo $passport | grep -q -E 'byr:(19[2-9][0-9]|200[0-2])\b' || echo "nope")
	iyr=$(echo $passport | grep -q -E 'iyr:(201[0-9]|2020)\b' || echo "nope")
	eyr=$(echo $passport | grep -q -E 'eyr:(202[0-9]|2030)\b' || echo "nope")
	hgt=$(echo $passport | grep -q -E 'hgt:(1[5-8][0-9]cm|19[0-3]cm|59in|6[0-9]in|7[0-6]in)\b' || echo "nope")
	hcl=$(echo $passport | grep -q -E 'hcl:#[0-9a-f]{6}\b' || echo "nope")
	ecl=$(echo $passport | grep -q -E 'ecl:(amb|blu|brn|gry|grn|hzl|oth)\b' || echo "nope")
	pid=$(echo $passport | grep -q -E 'pid:[0-9]{9}\b' || echo "nope")

	if [[ $byr || $iyr || $eyr || $hgt || $hcl || $ecl || $pid ]]
	then
		echo "false"
		return
	fi
	echo "true"
}

passport=""
count1=0
count2=0
while read -r line
do
	if [[ -z "$line" ]]
	then
		# passport is done
		if [[ $(check1 "$passport") == "true" ]]
		then
			count1=$((count1+1))
		fi
		if [[ $(check2 "$passport") == "true" ]]
		then
			# echo $passport
			count2=$((count2+1))
		fi
		passport=""
	else
		passport+=" $line"
	fi
done

# check the trailing passport
if [[ $(check1 "$passport") == "true" ]]
then
	count1=$((count1+1))
fi
if [[ $(check2 "$passport") == "true" ]]
then
	count2=$((count2+1))
fi

echo "Part 1: $count1"
echo "Part 2: $count2"
