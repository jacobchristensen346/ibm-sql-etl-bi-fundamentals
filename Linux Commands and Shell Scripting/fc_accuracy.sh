#! /usr/bin/bash

# Create a script to report historical forecasting accuracy
# this script will compare the forecasted temperature for a given day to the actual temperature that was observed
# requires the use of the rx_poc.log file and at least two entry rows in that log
# it is part of the practice project in the Linux Commands and Shell Scripting IBM course

# obtain the weather information for casablanca
city_name=casablanca # assign city name to variable
curl wttr.in/$city_name?T --output weather_report # insert variable into curl command and output into file

# below we get actual temperature that was seen for noon today
#act_temp=$(curl -s wttr.in/$city_name?T | grep '°.' | sed -n "2p" | grep -Eoe '|[^[:digit:]]*[[:digit:]][^[:space:]]*' | sed -n "2p" | grep -Eoe '[[:digit:]].*')
#echo "Here is the actual temperature for today at noon as loaded into a variable using curl and grep commands: $act_temp"

# below we get the temp that was forecasted for today, as input into our rx_poc.log file
# use the tail command to get the most recent line to use for the forecast
# then pipe to cut to get the final column of the row using tab delimiter
#fore_temp=$(tail -1 rx_poc.log | cut -f5 -d $'\t')
#echo "Here is the forecasted temperature for today at noon as loaded into a variable using curl and grep commands: $fore_temp"

# here we do the same thing above but using the rx_poc.log file instead, using the last two lines
# the last line in rx_poc.log will give us the observed temperature for the day
# the second to last line will give us the forecasted temperature for today at noon
# first we start with the forecast yesterday
# take the 2nd to last line for the forecasted temperature for today
# use the cut command to get the 5th item in the line which is the forecasted temp
fore_temp=$(tail -2 rx_poc.log | head -1 | cut -d $'\t' -f5)
echo "Here is the forecasted temperature for today at noon: $fore_temp"

# now take the last line of the rx_poc.log file
# take the 4th item in the line (tab delimited) as this is the observed temp found right at noon when the rx_poc.sh script runs
act_temp=$(tail -1 rx_poc.log | cut -f4 -d $'\t')
echo "Here is the actual temperature for today at noon: $act_temp"

# now we will find the accuracy
# let's do it by the difference between the actual and the forecasted for today
# we must also select the temperature out of the variables (since two are given in each variable), let's take the first
act_temp_first=$(echo $act_temp | grep -Eoe '|[^\(]*' | head -1)
fore_temp_first=$(echo $fore_temp | grep -Eoe '|[^\(]*' | head -1)
diff_temp=$(($act_temp_first-$fore_temp_first))
echo "Here is the difference between the actual and the forecasted temperature: $diff_temp"

# now we will assign a label to the temperature difference based on how accurate the forecast was
# +/- 1 deg = excellent
# +/- 2 deg = good
# +/- 3 deg = fair
# +/- 4 deg = poor
if [[ $diff_temp == -1 ]] || [[ $diff_temp == +1 ]]
then
    acc_label=excellent
elif [[ $diff_temp == -2 ]] || [[ $diff_temp == +2 ]]
then
    acc_label=good
elif [[ $diff_temp == -3 ]] || [[ $diff_temp == +3 ]]
then    
    acc_label=fair    
elif [[ $diff_temp == -4 ]] || [[ $diff_temp == +4 ]]    
then
    acc_label=poor
else
    acc_label=TERRIBLE
fi
echo "Here is the accuracy label for the forecasted temperature: $acc_label"

# now we will append this data to the historical_fc_accuracy.tsv log
# append the data for today's date, and how good the forecast was
today_row=$(tail -1 rx_poc.log)
year=$(echo $today_row | cut -d " " -f1)
month=$(echo $today_row | cut -d " " -f2)
day=$(echo $today_row | cut -d " " -f3)
echo -e "$year\t$month\t$day\t$acc_label\t$diff_temp" > tmp_hist_row.txt
cat tmp_hist_row.txt >> historical_fc_accuracy.tsv
rm tmp_hist_row.txt
echo "Here is the historical log so far..."; cat historical_fc_accuracy.tsv


