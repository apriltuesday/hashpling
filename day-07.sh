#!/usr/local/bin/bash

# via https://unix.stackexchange.com/questions/251013/bash-regex-capture-group
global_rematch() { 
    local s=$1 regex=$2 
    while [[ $s =~ $regex ]]; do 
        echo "${BASH_REMATCH[1]}"
        s=${s#*"${BASH_REMATCH[1]}"}
    done
}

# Make a tree: b1 -> b2 if b1 can be contained in b2
# Data structure: tree as associative array
#   node -> comma-separated string of children
#   e.g. 'shiny gold' -> 'bright white,muted yellow'
declare -A tree

# Part 2
# b1,b2 -> number of b1s contained in b2
declare -A nums

node_regex="(.*) bags contain"
parent_regex="[0-9]+ ([^0-9]*) bag"
while read -r line
do
	# node match must be second so we capture the correct child node
	if [[ $line =~ $parent_regex && $line =~ $node_regex ]]
	then
		child="${BASH_REMATCH[1]}"
		while read -r parent
		do
			if [[ -z ${tree[$parent]} ]]
			then
				tree[$parent]="$child"
			else
				tree[$parent]+=",$child"
			fi
			# get the number of parents contained in child
			num_regex="([0-9]+) $parent bag"
			if [[ $line =~ $num_regex ]]
			then
				nums["$parent,$child"]="${BASH_REMATCH[1]}"
			fi
		done <<< $(global_rematch "$line" "$parent_regex")
	fi
done

# Gets list of all nodes in subtree for a given root
visit_nodes () {
	local current="$1"
	local visited="$2"  # comma-sep string of visited nodes
	if [[ -z $visited ]]
	then
		visited="$current"
	else
		visited+=",$current"
	fi

	IFS=',' read -r -a children <<< "${tree[$current]}"
	for c in "${children[@]}"
	do
		if [[ -n $c ]]
		then
			if [[ "$visited" != *"$c"* ]]
			then
				visited=$(visit_nodes "$c" "$visited")
			fi
		fi
	done
	echo $visited
}

# Counts all the bags backwards from root
# NOTE: this is not a good solution.
backwards_count () {
	local current="$1"
	total=1  # include self
	for key in "${!tree[@]}"
	do
		IFS=',' read -r -a children <<< "${tree[$key]}"
		for c in "${children[@]}"
		do
			if [[ "$c" == "$current" ]]
			then
				x=${nums["$key,$current"]}
				y=$(backwards_count "$key")
				total=$((total+x*y))
			fi
		done
	done
	echo $total
}

root="shiny gold"

# part 1
visited=$(visit_nodes "$root" "")
IFS=',' read -r -a nodes <<< "$visited"
total1=${#nodes[@]}  # includes root
echo "Part 1: $((total1-1))"

# part 2
total2=$(backwards_count "$root")  # includes root
echo "Part 2: $((total2-1))"
