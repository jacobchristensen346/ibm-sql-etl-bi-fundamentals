"""
----------------------------
generate_data_quality_report
----------------------------

This script serves as the root or entry point for generating
a report for data verification.

After connecting to the database of interest, each
test and its parameters are read into a new dictionary.
We iterate through these tests and call the data quality check
module methods to execute the actual database queries.

Once completed, the test results are loaded into a dataframe
and displayed in tabulated form as a quality summary.
"""

import os
import psycopg2
import pandas as pd
from tabulate import tabulate

# Import the tests and their parameters.
import mytests
# Import the data quality checks.
# These perform the actual testing
# according to the parameters given in 'mytests'.
from dataqualitychecks import check_for_nulls
from dataqualitychecks import check_for_min_max
from dataqualitychecks import check_for_valid_values
from dataqualitychecks import check_for_duplicates
from dataqualitychecks import run_data_quality_check

# Connect to database of interest.
pgpassword = "Ff6H8z2uJ45f5jpnaZlm1xtL"
conn = psycopg2.connect(
		user = "postgres",
	    password = pgpassword,
	    host = "postgres",
	    port = "5432",
	    database = "billingDW")

print("Connected to data warehouse")

# Start of data quality checks.
results = []
# Iterate through the namespace of the 'mytests' module.
# Create a new dictionary where the keys are each test variable name
# and the values are a dictionary themselves, comprised of the 
# parameters for each test.
tests = {key:value for key,value in mytests.__dict__.items() if key.startswith('test')}
# Iterate through the tests and execute the data quality checks
# according to the test paramters.
for testname,test in tests.items():
    test['conn'] = conn
    results.append(run_data_quality_check(**test))

# Tabulate and display results.
#print(results)
df=pd.DataFrame(results)
df.index+=1
df.columns = ['Test Name', 'Table','Column','Test Passed']
print(tabulate(df,headers='keys',tablefmt='psql'))
# End of data quality checks.
conn.close()
print("Disconnected from data warehouse")
