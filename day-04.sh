#!/usr/local/bin/bash
fields=(byr iyr eyr hgt hcl ecl pid)
count=0
passport=""

check () {
	passport=$1
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

while read -r line
do
	if [[ -z "$line" ]]
	then
		# passport is done
		valid=$(check "$passport")
		if [[ $valid == "true" ]]
		then
			count=$((count+1))
		fi
		passport=""
	else
		passport+=" $line"
	fi
done

# check the trailing passport
if [[ $(check "$passport") == "true" ]]
then
	count=$((count+1))
fi

echo $count
