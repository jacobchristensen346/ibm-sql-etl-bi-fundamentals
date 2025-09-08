#~ /usr/bin/bash

# Create a script to report weekly statistics of historical forecasting accuracy
# part of the practice project for the IBM Linux Commands and Shell Scripting course

# let's load the accuracy data into an array
# we will do it for the last week (7 days)
# run through a loop seven times for the seven days
# each time, grab the accuracy value from one of the seven rows for each day
# load that accuracy value into the array
num_days=7
declare -a accur_array # empty array
for (( i=0; i<=$(($num_days-1)); i++ )) ; do
    accur_array+=($(tail -7 synthetic_historical_fc_accuracy.tsv | sed -n "$(($i+1))p" | cut -d $'\t' -f6))
    echo -e "Here is the current element value of the accuracy array: ${accur_array[$i]}"
done
echo -e "Here is the final accuracy array... ${accur_array[@]}"

# here is another way to do this
# load the 6th element of each of the seven rows into a txt file
# then use cat and echo to load those results into the array
# echo $(tail -7 synthetic_historical_fc_accuracy.tsv  | cut -f6) > scratch.txt
# week_fc=($(echo $(cat scratch.txt)))

# now we will output the minimum and maximum absolute forecasting errors
# take the absolute value of each accuracy value
# then find the minimum and maximum
# to take the absolute value, we will use the general parameter substitution functionality ${variable}
# using the specific functionality of expanding the variable starting from an offset ${variable:OFFSET}
for i in ${!accur_array[@]}; do # the '!' enumerates the array rather than returning its actual elements
    if [[ ${#accur_array[$i]} > 1 ]]
    then
        accur_array[$i]=$(echo ${accur_array[$i]:1})
    fi
    echo -e "Here is the absolute value of the current index position: ${accur_array[$i]}"
done
echo -e "Here is the array with absolute values... ${accur_array[@]}"

# now find the maximum value...

maximum_value=${accur_array[0]}
for i in ${!accur_array[@]}; do
    if [[ $i > 0 ]]
    then
        if [[ ${accur_array[$i]} > $maximum_value ]]
        then
            maximum_value=${accur_array[$i]}
        fi
    fi
done
echo "Here is the maximum value: $maximum_value"

# now find the minimum value...

minimum_value=${accur_array[0]}
for i in ${!accur_array[@]}; do
    if [[ $i > 0 ]]
    then
        if [[ ${accur_array[$i]} < $minimum_value ]]
        then
            minimum_value=${accur_array[$i]}
        fi
    fi
done
echo "Here is the minimum value: $minimum_value"

# an alternative way to find the maximum and minimum values is through using the sort command
# first you must tell bash to output contents with newline characters in between instead of spaces or tabs
# then the echo function will output a column of data that sort can operate on. Use the -n flag to sort numerically
# then use the tail function to obtain the final item which will be the largest number, and head to retrieve the smallest number
# IFS=$'\n'
# maximum_value=$(echo "${accur_array[*]}" | sort -n | tail -1)
# minimum_value=$(echo "${accur_array[*]}" | sort -n | head -1)
