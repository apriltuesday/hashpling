#!/usr/local/bin/bash
# ^ for associative arrays, need bash4+
diffs1=()
declare -A diffs2
while read -r line
do
	# part 1
  val=$((line+0))
  diff=$((2020-val))
  if [[ "${diffs1[@]}" =~ "${val}" ]]
  then
  	echo "Part 1: $((diff*val))"
  	# break
  fi
  diffs1+=($diff)

  # part 2
  for k in "${!diffs2[@]}"
  do
  	# 1. if val is in the list, return k*val*(2020-k-val)
  	# 2. otherwise append 2020-k-val to the list
  	IFS=',' read -r -a list <<< "${diffs2[$k]}"
  	newval=$((2020-k-val))
  	if [[ "${list[@]}" =~ "${val}" ]]
  	then
  		echo "Part 2: $((k*val*newval))"
  		# break
  	else
  		if [[ $newval -gt 0 ]]
  		then
	  		diffs2[$k]+=",$newval"
	  	fi
	  fi
  done
  diffs2[$val]=""
done
