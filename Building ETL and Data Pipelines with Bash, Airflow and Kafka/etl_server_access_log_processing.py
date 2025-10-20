# Import the libraries
from datetime import timedelta
# The DAG object; we'll need this to instantiate a DAG
from airflow.models import DAG
# Python and Bash operators
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator

# This makes scheduling easy
from airflow.utils.dates import days_ago
# this is needed to download file from remote server
import urllib.request
# to create directories
import os

# the remote server to download the file from
remote_server = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Apache%20Airflow/Build%20a%20DAG%20using%20Airflow/web-server-access-log.txt"
remote_file_name = "web-server-access-log.txt" # name to be given to downloaded file
extracted_file = "extracted.txt" # name for file with extracted contents
transformed_file = "transformed.txt" # name for file with transformed contents
output_file = "/home/project/capitalized.csv" # name of output csv data is loaded into

# function to download remote file and extract desired contents of remote file
def extract(remote_server, remote_file_name, extracted_file):
    urllib.request.urlretrieve(remote_server, remote_file_name)
    with open(remote_file_name, "r") as in_file, open(extracted_file, "w") as extract_file:
        for line in in_file:
            split_line = line.split("#")
            time_stamp = split_line[0]
            visitor_id = split_line[3]
            extract_file.write(time_stamp + "#" + visitor_id + "\n")

# function to transform extracted contents of remote file
def transform(extracted_file, transformed_file):
    with open(extracted_file, "r") as extract_file, open(transformed_file, "w") as trans_file:
        for line in extract_file:
            split_line = line.split("#")
            time_stamp = split_line[0]
            capitalize_id = split_line[1].capitalize()
            trans_file.write(time_stamp + "," + capitalize_id + "\n")

# function to load data into a csv file
def load(transformed_file, output_file):
    with open(transformed_file, "r") as trans_file, open(output_file, "w") as out_file:
        for line in trans_file:
            out_file.write(line + "\n")

# now we must define our default DAG parameters
default_args = {
    'owner': 'Your name',
    'start_date': days_ago(0),
    'email': ['your email'],
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}
        
# Define the DAG
dag = DAG(
    'etl-server-access-log-processing',
    default_args=default_args,
    description='Perform a simple ELT process in Python using remote txt file',
    schedule_interval=timedelta(days=1),
)

# define a Python operator which will be the extract step
extract_operation = PythonOperator(
    task_id = 'extract',
    python_callable = extract,
    op_args = [remote_server, remote_file_name, extracted_file],
    dag = dag
)

# define a Python operator which will be the transform step
transform_operation = PythonOperator(
    task_id = 'transform',
    python_callable = transform,
    op_args = [extracted_file, transformed_file],
    dag = dag
)

# define a Python operator which will be the load step
load_operation = PythonOperator(
    task_id = 'load',
    python_callable = load,
    op_args = [transformed_file, output_file],
    dag = dag
)

# now we define the order of operations for our DAG
extract_operation >> transform_operation >> load_operation
