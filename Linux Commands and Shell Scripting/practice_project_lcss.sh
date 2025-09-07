#! /usr/bin/bash

# this script collects weather data for casablanca and outputs into a log file
# it is the practice project for the Linux Commands and Shell Scripting IBM course

# first create a log file to hold all of our final output
# commented out since it only needs to happen once, don't keep doing it else the file is always overwritten!
# echo -e "year\tmonth\tday\tobs_temp\tfc_temp">rx_poc.log

# obtain the weather information for casablanca
city_name=casablanca # assign city name to variable
curl wttr.in/$city_name?T --output weather_report # insert variable into curl command and output into file

# now load current temperature into a variable
# we first obtain the whole weather output for casablanca using the curl command
# then we pipe the output to grep command which finds all lines with '°.' (the '.' refers to any possible single character), but selects only the first (-m 1 option)
# those lines are then piped to another grep command which does a more complicated filter
# the -E option allows extended regular expressions so we can use special grep metacharacters
# the -o option selects only the output from the grep command which exactly matches the pattern given (so not the whole line)
# the -e option ensures we can use the "-" character in our pattern
# Now for the pattern itself. The ? character tells us that the "-" character is optional to match and may be repeated some number of times
# The [[:digit:]] expression says that the next character can be any single digit
# The [^[:space:]] option means that the next character will be anything BUT a whitespace character (because of the ^ included)
# finally the * character means that the previous character will be repeated zero to any number of times
# so the matching continues up to the first instance of a whitespace
obs_temp=$(curl -s wttr.in/$city_name?T | grep -m 1 '°.' | grep -Eoe '-?[[:digit:]][^[:space:]]*')
echo "Here is the current temperature as loaded into a variable using curl and grep commands: $obs_temp"

# now we will extract tomorrow's temperature forecast for noon
fc_temp=$(curl -s wttr.in/$city_name?T | grep '°.' | sed -n "3p" | grep -Eoe '|[^[:digit:]]*[[:digit:]][^[:space:]]*' | sed -n "2p" | grep -Eoe '[[:digit:]].*')
echo "Here is the weather forecast for tomorrow loaded into a variable using curl and grep commands: $fc_temp"

# Need to set date variable TZ (timezone) to casablanca
TZ='Morocco/Casablanca'
date >> tmp_data.txt
# now let's grab the current day, month, and year and place them into variables
day=$(grep -Eoe '[^[:space:]]*' tmp_data.txt | sed -n "3p")
month=$(grep -Eoe '[^[:space:]]*' tmp_data.txt | sed -n "2p")
year=$(grep -Eoe '[^[:space:]]*' tmp_data.txt | sed -n "6p")
rm tmp_data.txt

echo -e "Here is the current day, month, and year, respectively: $day\t$month\t$year"

# now let's merge the stuff we've collected into a single row in a table (weather log file rx_poc.log)
# append it since we already have a header row
# don't use paste since we want it to append as a row, not as a column
# instead use cat and redirect output to append onto the log file
echo -e "$year\t$month\t$day\t$obs_temp\t$fc_temp" > new_row.txt
cat new_row.txt >> rx_poc.log
rm new_row.txt
echo "Here is the log file so far..."; cat rx_poc.log
