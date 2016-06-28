#!/bin/bash

# path of the SDK root folder
SDK_PATH=""
ADB_PATH=$SDK_PATH"adb"

# read list of devices, extract only di identifiers, and create an array with them
devices=($($ADB_PATH devices | grep -oE "^((\d{1,3}(\.\d{1,3}){3}:\d{1,5})|(\w+))"))
# remove header
devices=("${devices[@]:1:${#devices[@]}}")

if [[ ${#devices[@]} > 1  ]]; then
	# show a list of devices from which select the use to use
	echo "Found "${#devices[@]}" devices"
	selected=-1
	while [[  $selected -lt 0 || $selected -ge ${#devices[@]} ]]; do
		echo "Insert the number of the device to use:"
		for index in "${!devices[@]}"
		do
		    echo "$index) ${devices[index]}"
		done

		# read user's input
		read selected
		echo ""
		echo ""
	done

	device=${devices[$selected]}

else
	device=${devices[0]}
fi

echo "Selected the device: "$device

$ADB_PATH -s $device logcat -c
$ADB_PATH -s $device logcat | grep -n -oE $1