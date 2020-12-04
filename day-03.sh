#!/usr/local/bin/bash
read -d '' -r -a lines
height=${#lines[@]}
width=${#lines[0]}

# xy == right x, down y
slopes=(11 31 51 71 12)
prod=1
for slope in ${slopes[@]}
do
	right=${slope:0:1}
	down=${slope:1:1}
	currX=0
	currY=0
	count=0

	while [[ $currY -le $height ]]
	do
		currC=${lines[$currY]:$currX:1}
		if [[ $currC == '#' ]]
		then
			count=$((count+1))
		fi
		currY=$((currY+down))
		currX=$(( (currX+right)%width ))
	done

	echo "Right $right, down $down: $count"
	prod=$((prod*count))
done

echo $prod
