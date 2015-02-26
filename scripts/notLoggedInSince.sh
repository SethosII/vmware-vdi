#!/bin/bash

# prints all vms not logged in since a specified date
# first argument is date to compare to
# run in the vmusage folder
# much faster then the powershell script

lastUsed=$(for i in *.csv
do
	echo -n "`echo $i | cut -d "." -f 1` : "; tac $i | grep -m 1 -v -E 'nobody|admeps'; echo ""
done | grep -v "^$")

date=`date -d $1 "+%s"`
while read -r line
do
	# extract date
	dateLine=`echo "$line" | awk -F" " '{ print $3 }'`
	if [[ -z "$dateLine" ]]
	then
		# dateLine empty, set to "begining of time"
		dateLine=`date -d 2014/12/01 "+%s"`
	else
		# convert date to UNIX timestamp
		dateLine=`date -d $dateLine "+%s"`
	fi

	if [[ $dateLine < $date ]]
	then
		# print vm
		echo $line
	fi
done <<< "$lastUsed"
