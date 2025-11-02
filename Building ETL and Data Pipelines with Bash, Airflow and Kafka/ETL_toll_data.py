""" Lab: Build ETL Data Pipelines with BashOperator using Apache Airflow

Final project of the "Building ETL and Data Pipelines with Bash, Airflow and Kafka" course
from IBM

Creating a ETL DAG for highway toll data...
    - Extract data from a csv file
    - Extract data from a tsv file
    - Extract data from a fixed-width file
    - Transform the data
    - Load the transformed data into the staging area
"""

# libraries import
from datetime import timedelta
# The DAG object; we'll need this to instantiate a DAG
from airflow.models import DAG
# Operators to write tasks
from airflow.operators.bash_operator import BashOperator
# This makes scheduling easy
from airflow.utils.dates import days_ago

# defining default DAG arguments
default_args = {
    'owner': 'John Doe',
    'start_date': days_ago(0),
    'email': ['johndoe324@gmail.com'],
    'email_on_failure': True,
    'email_on_retry': True,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# define the DAG
dag = DAG(
    'ETL-toll-data',
    default_args=default_args,
    description='Apache Airflow Final Assignment',
    schedule_interval=timedelta(days=1),
)

# define the tasks

# define the first task to unzip the data
unzip_data = BashOperator(
    task_id='unzip_data',
    bash_command='tar -xvzf /home/project/airflow/dags/finalassignment/tolldata.tgz -C /home/project/airflow/dags/finalassignment/',
    dag=dag,
)

# define the second task to extract data from the csv
extract_data_from_csv = BashOperator(
    task_id='extract_data_from_csv',
    bash_command='cut -d"," -f1,2,3,4 /home/project/airflow/dags/finalassignment/vehicle-data.csv > /home/project/airflow/dags/finalassignment/csv_data.csv',
    dag=dag,
)

# define the third task to extract data from the tsv
extract_data_from_tsv = BashOperator(
    task_id='extract_data_from_tsv',
    bash_command='cut -f5,6,7 /home/project/airflow/dags/finalassignment/tollplaza-data.tsv | tr "\\t" "," | tr -d "\\r" > /home/project/airflow/dags/finalassignment/tsv_data.csv',
    dag=dag,
)

# define the fourth task to extract data from the fixed-width file
extract_data_from_fixed_width = BashOperator(
    task_id='extract_data_from_fixed_width',
    bash_command='tr -s "[:space:]" < /home/project/airflow/dags/finalassignment/payment-data.txt | cut -d" " -f11,12 | tr " " "," > /home/project/airflow/dags/finalassignment/fixed_width_data.csv',
    dag=dag,
)

# define the fifth task to consolidate data
consolidate_data = BashOperator(
    task_id='consolidate_data',
    bash_command='cd /home/project/airflow/dags/finalassignment/; paste -d"," csv_data.csv tsv_data.csv fixed_width_data.csv > extracted_data.csv',
    dag=dag,
)

# define the sixth task to transform data
transform_data = BashOperator(
    task_id='transform_data',
    bash_command='cd /home/project/airflow/dags/finalassignment/; (paste -d "," <(cut -d"," -f1-3 extracted_data.csv) <(cut -d"," -f4 extracted_data.csv | tr "[:lower:]" "[:upper:]") <(cut -d"," -f5-9 extracted_data.csv)) > staging/transformed_data.csv',
    dag=dag,
)

# task pipeline
unzip_data >> extract_data_from_csv >> extract_data_from_tsv >> extract_data_from_fixed_width >> consolidate_data >> transform_data