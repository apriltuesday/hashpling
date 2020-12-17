#!/usr/local/bin/bash
IFS=$'\n' read -d '' -r -a lines

# parse input
n=${#lines[@]}
declare -A rules
tickets=()
mine=""
i=0
rule_regex="([^0-9:]+): ([0-9]+-[0-9]+ or [0-9]+-[0-9]+)"
while [[ $i -lt $n ]]
do
	line="${lines[$i]}"
	if [[ $line =~ $rule_regex ]]
	then
		name="${BASH_REMATCH[1]}"
		ranges="${BASH_REMATCH[2]}"
		rules[$name]=$ranges
		i=$((i+1))
	elif [[ $line == "your ticket:" ]]
	then
		mine=${lines[$((i+1))]}
		i=$((i+3))
	else  # must be nearby ticket
		tickets+=("$line")
		i=$((i+1))
	fi
done

# check validity
range_regex="([0-9]+)-([0-9]+) or ([0-9]+)-([0-9]+)"

check_rule () {
	local n=$1
	local rule=$2

	if [[ $rule =~ $range_regex ]]
	then
		lo1="${BASH_REMATCH[1]}"
		hi1="${BASH_REMATCH[2]}"
		lo2="${BASH_REMATCH[3]}"
		hi2="${BASH_REMATCH[4]}"
		if [[ $n -ge $lo1 && $n -le $hi1 ]] || [[ $n -ge $lo2 && $n -le $hi2 ]]
		then
			echo "true"
			return
		fi
	fi
	echo "false"
}

sum=0
valid_tickets=($mine)
for ticket in ${tickets[@]}
do
	ticket_valid="true"
	IFS=',' read -r -a nums <<< "$ticket"
	for n in ${nums[@]}
	do
		n_valid="false"
		for rule in "${rules[@]}"
		do
			if [[ $(check_rule "$n" "$rule") == "true" ]]
			then
				n_valid="true"
			fi
		done
		if [[ $n_valid == "false" ]]
		then
			sum=$((sum+n))
			ticket_valid="false"
		fi
	done

	if [[ $ticket_valid == "true" ]]
	then
		valid_tickets+=($ticket)
	fi
done

echo "Part 1: $sum"

# part two strategy:
# each index has a list of candidate field names
# go through valid tickets and remove names that are invalid
candidates=()
anticandidates=()  # ensures we don't re-add things
for ticket in ${valid_tickets[@]}
do
	IFS=',' read -r -a nums <<< "$ticket"
	for idx in ${!nums[@]}
	do
		n=${nums[$idx]}
		for name in "${!rules[@]}"
		do
			rule=${rules[$name]}
			valid=$(check_rule "$n" "$rule")
			cands="${candidates[$idx]}"
			anticands="${anticandidates[$idx]}"
			if [[ $valid == "true" ]] && [[ ! "$cands" =~ "$name" ]] && [[ ! "$anticands" =~ "$name" ]]
			then
				candidates[$idx]="$cands$name"
			elif [[ $valid == "false" ]] && [[ "$cands" =~ "$name" ]]
			then
				candidates[$idx]="${cands/$name}"
				anticandidates[$idx]="$anticands$name"
			fi
		done
	done
done

# filter out repeat names
repeats="true"
while [[ $repeats == "true" ]]
do
	repeats="false"
	for i in ${!candidates[@]}
	do
		name="${candidates[$i]}"
		for j in ${!candidates[@]}
		do
			if [[ $i -eq $j ]]
			then
				continue
			fi
			other="${candidates[$j]}"
			if [[ "$other" == *"$name"* ]]
			then
				candidates[$j]="${other/$name}"
				repeats="true"
			fi
		done
	done
done

# finally get the result
IFS=',' read -r -a nums <<< "$mine"
prod=1
for idx in ${!candidates[@]}
do
	if [[ ${candidates[$idx]} =~ "departure" ]]
	then
		n=${nums[$idx]}
		prod=$((prod*n))
	fi
done

echo "Part 2: $prod"
