#! /bin/bash
# This script
# Extracts data from /etc/passwd file into a CSV file.

# The csv data file contains the user name, user id and
# home directory of each user account defined in /etc/passwd

# Transforms the text delimiter from ":" to ",".
# Loads the data from the CSV file into a table in PostgreSQL database.

# arguments to pass to script are as follows...
# $1: path to file containing source data
# $2: copy and transform data to this destination path
# $3: PostgreSQL database name
# $4: PostgreSQL username
# $5: PostgreSQL password

source_file=$1
dest_path=$2
pg_database=$3
pg_username=$4
pg_password=$5

# Extract phase

echo "Extracting data"

# Extract the columns 1 (user name), 2 (user id) and 
# 6 (home directory path) from /etc/passwd

cut -d":" -f1,3,6 ${source_file} > ${dest_path}/extracted-data.txt

# Transform phase
echo "Transforming data"
# read the extracted data and replace the colons with commas.

tr ":" "," < ${dest_path}/extracted-data.txt  > ${dest_path}/transformed-data.csv

# Load phase
echo "Loading data"
# Set the PostgreSQL password environment variable.
# Replace <yourpassword> with your actual PostgreSQL password.
# Pass the password as argument to the script on command line.
export PGPASSWORD=${pg_password};
# Send the instructions to connect to 'template1' and
# copy the file to the table 'users' through command pipeline.
echo "\c ${pg_database};\COPY users  FROM '${dest_path}/transformed-data.csv' DELIMITERS ',' CSV;" | psql --username=${pg_username} --host=postgres

echo "SELECT * FROM users;" | psql --username=${pg_username} --host=postgres ${pg_database}
