# Practice exercise script
# Copy the data in the file ‘web-server-access-log.txt.gz’ to the table ‘access_log’ in the PostgreSQL database ‘template1’.

# The following are the columns and their data types in the file:

#    a. timestamp - TIMESTAMP
#    b. latitude - float
#    c. longitude - float
#    d. visitorid - char(37)
#    e. accessed_from_mobile - boolean
#    f. browser_code - int

# PostgreSQL database, username, and password...
pg_database=$1
pg_username=$2
pg_password=$3

# destination path to place filtered data from source file
dest_path=$4

echo "Creating SQL table"
# Set the PostgreSQL password environment variable.
# Replace <yourpassword> with your actual PostgreSQL password.
# Pass the password as argument to the script on command line.
export PGPASSWORD=${pg_password};
# Send the instructions to connect to 'template1' and
# create a new table called "access_log"
echo "\c ${pg_database}" | psql --username=${pg_username} --host=postgres
# optional drop table if we want to start fresh
# echo "DROP TABLE access_log;" | psql --username=${pg_username} --host=postgres ${pg_database}
echo "CREATE TABLE access_log(timestamp TIMESTAMP, latitude float, longitude float, visitor_id char(37));" | psql --username=${pg_username} --host=postgres ${pg_database}

# Download the access log file.

echo "Downloading source file"
wget "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Bash%20Scripting/ETL%20using%20shell%20scripting/web-server-access-log.txt.gz"

# unzip the gzip file

gunzip -f web-server-access-log.txt.gz

# Extract the required fields from the file (timestamp, latitude, longitude, and visitorid -> first four fields in the txt file)
# Redirect the extracted output into a new file

echo "Extracting the desired data"
cut -d"#" -f1-4 web-server-access-log.txt > ${dest_path}/extracted_data.txt

# Transform the data to csv format

echo "Transforming the data"
tr "#" "," < ${dest_path}/extracted_data.txt > ${dest_path}/transformed_data.csv

# Load the data into the table "access_log" in PostgreSQL which was created at the beginning of the script

echo "Loading data into database table"
echo "\COPY access_log FROM '${dest_path}/transformed_data.csv' WITH (FORMAT CSV, HEADER);" | psql --username=${pg_username} --host=postgres ${pg_database}

# now query the database for the table contents that we just loaded with data

echo "SELECT * FROM access_log;" | psql --username=${pg_username} --host=postgres ${pg_database}
