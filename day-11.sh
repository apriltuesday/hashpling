#!/usr/local/bin/bash
IFS=$'\n' read -d '' -r -a array
height=${#array[@]}
width=${#array[0]}

next_state () {
	local row=$1
	local col=$2
	local curr=$3

	if [[ $curr == "." ]]
	then
		echo $curr
		return
	fi

	# count occupied seats
	count=0
	row_lo=$((row>0 ? row-1 : 0))
	row_hi=$((row<height-1 ? row+1 : height-1))
	col_lo=$((col>0 ? col-1 : 0))
	col_width=$((col>0 ? 3 : 2))

	for (( i=$row_lo; i<=$row_hi; i++ ))
	do
		string=${array[$i]:$col_lo:$col_width}
		n_occ=$(awk -F"#" '{print NF-1}' <<< "${string}")
		# >&2 echo "$string: $n_occ"
		if [[ $i == $row && $curr == "#" ]]
		then
			n_occ=$((n_occ-1))
		fi
		count=$((count+n_occ))
	done

	if [[ $count -eq 0 ]]
	then
		echo "#"
	elif [[ $count -ge 4 ]]
	then
		echo "L"
	else
		echo $curr
	fi
}

# part 1: works on test but too slow for input
diff="true"
while [[ $diff == "true" ]]
do
	array=(${next_array[@]})
	next_array=()
	diff="false"
	count_occ=0
	for (( i=0; i<$height; i++ ))
	do
		for (( j=0; j<$width; j++ ))
		do
			curr=${array[$i]:$j:1}
			next=$( next_state $i $j $curr)
			if [[ $next != $curr ]]
			then
				diff="true"
			fi
			if [[ $next == "#" ]]
			then
				count_occ=$((count_occ+1))
			fi
			next_array[$i]="${next_array[$i]}$next"
		done
	done
done

echo "Part 1: $count_occ"
