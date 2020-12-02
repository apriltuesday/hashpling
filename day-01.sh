#!/bin/bash
diffs=()
while read -r line
do
  val=$((line+0))
  key=$((2020-val))
  if [[ " ${diffs[@]} " =~ " ${val} " ]]
  then
  	echo $((key*val))
  	break
  fi
  diffs+=($key)
done
