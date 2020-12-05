#!/usr/local/bin/bash
max=0
seats=()
while read -r line
do
	lo=0
	hi=128
	for (( i=0; i<7; i++ ))
	do
		c=${line:$i:1}
		half=$(( (hi-lo)/2 ))
		if [[ $c == "F" ]]
		then
			hi=$((lo+half))
		else # c is "B"
			lo=$((hi-half))
		fi
	done
	row=$lo

	lo=0
	hi=8
	for (( i=7; i<10; i++ ))
	do
		c=${line:$i:1}
		half=$(( (hi-lo)/2 ))
		if [[ $c == "L" ]]
		then
			hi=$((lo+half))
		else # c is "R"
			lo=$((hi-half))
		fi
	done
	col=$lo

	seat=$((row*8+col))
	if [[ $seat > $max ]]
	then
		max=$seat
	fi
	seats+=($seat)
done

echo "Part 1: $max"

mine=""
for seat in ${seats[@]}
do
	if [[ "${seats[@]}" =~ "$((seat-2))" ]]
	then
		test=$((seat-1))
		if [[ ! "${seats[@]}" =~ "$test" ]]
		then
			mine=$test
		fi
	elif [[ "${seats[@]}" =~ "$((seat+2))" ]]
	then
		test=$((seat+1))
		if [[ ! "${seats[@]}" =~ "$test" ]]
		then
			mine=$test
		fi
	fi
done

echo "Part 2: $mine"
