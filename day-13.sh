#!/usr/local/bin/bash
IFS=$'\n' read -d '' -r -a lines

time=${lines[0]}
IFS=',' read -r -a ids <<< "${lines[1]}"

# Part 1
for id in ${ids[@]}
do
	if [[ $id != "x" ]]
	then
		diff=$((id-(time%id)))
		if [[ -z $min_diff ]] || [[ $diff -lt $min_diff ]]
		then
			min_diff=$diff
			min_id=$id
		fi
	fi
done

echo "Part 1: $((min_id*min_diff))"

# Part 2
# NB. in the input all the ids are prime,
# though this isn't stated in the problem description

# return modular multiplicative inverse of a mod n
inverse () {
	a=$1
	n=$2

	t=0
	r=$n
	new_t=1
	new_r=$a

	while [[ new_r -ne 0 ]]
	do
		quotient=$((r/new_r))
		old_t=$t
		old_r=$r
		t=$new_t
		new_t=$((old_t-quotient*new_t))
		r=$new_r
		new_r=$((old_r-quotient*new_r))
	done

	t=$((t+n))
	echo $t
}

r=0  # current remainder
p=${ids[0]}  # current modulo (note in the input this isn't x)
n=${#ids[@]}
for (( i=1; i<n; i++ ))
do
	id=${ids[$i]}
	if [[ $id != "x" ]]
	then
		num=$(( (-i-r)%id ))
		num=$(( num<0 ? num+id : num ))
		den=$(inverse $p $id)
		prod=$(( p*num*den ))
		p=$(( p*id ))
		r=$(( (r+prod)%p ))
	fi
done

echo "Part 2: $r"
