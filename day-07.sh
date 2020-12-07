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
		done <<< $(global_rematch "$line" "$parent_regex")
	fi
done

# Gets list of all nodes reachable from a given root
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

# Count nodes in subtree rooted at 'shiny gold' (excluding root)
visited=$(visit_nodes "shiny gold" "")
IFS=',' read -r -a nodes <<< "$visited"
total=${#nodes[@]}  # includes root
echo "Part 1: $((total-1))"
