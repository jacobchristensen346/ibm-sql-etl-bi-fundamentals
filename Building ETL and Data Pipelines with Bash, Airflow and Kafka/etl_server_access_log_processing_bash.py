# import the libraries first

from datetime import timedelta
# The DAG object; we'll need this to instantiate a DAG
from airflow.models import DAG
# Operators; you need this to write tasks!
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
# This makes scheduling easy
from airflow.utils.dates import days_ago

# for downloading the file
import urllib.request

remote_server = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Apache%20Airflow/Build%20a%20DAG%20using%20Airflow/web-server-access-log.txt"
remote_file_name = "/home/project/web-server-access-log.txt"

# python function to download file
def download(remote_server, remote_file_name):
    urllib.request.urlretrieve(remote_server, remote_file_name)

# defining the default arguments for the dag
default_args = {
    'owner' : 'Jacob Christensen',
    'start_date' : days_ago(0),
    'email' : ['your_email'],
    'retries' : 1,
    'retry_delay' : timedelta(minutes = 5)
}

# create the dag
dag = DAG(
    'my-first-dag-bash',
    default_args = default_args,
    description = 'My First DAG',
    schedule_interval = timedelta(days = 1)
)

## now create the download task for the dag
## retrieves txt file from the server
#download_task = BashOperator(
#    task_id = 'download',
#    bash_command = 'wget -P "/home/project/" "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Apache%20Airflow/Build%20a%20DAG%20using%20Airflow/web-server-access-log.txt"',
#    dag = dag
#)

# download done with python operator since wget not available in Apache worker
download_task = PythonOperator(
    task_id = 'download',
    python_callable = download,
    op_args = [remote_server, remote_file_name],
    dag = dag
)


# create the extract task
# extracts the timestamp and visitorid columns from the downloaded txt file
extract_task = BashOperator(
    task_id = 'extract',
    bash_command = 'cut -d "#" -f1,4 "/home/project/web-server-access-log.txt" > "/home/project/extracted.txt"',
    dag = dag
)

# create the transform task
# capitalizes the visitorid column
transform_task = BashOperator(
    task_id = 'transform',
    bash_command = 'head -n +1 "/home/project/extracted.txt" > "/home/project/transformed.txt"; tail -n +2 "/home/project/extracted.txt" | awk \'{$2 = toupper($2)}1\' >> "/home/project/transformed.txt"',
    dag = dag
)

# create the load task
# compresses the transformed txt file
load_task = BashOperator(
    task_id = 'load',
    bash_command = 'tar -czvf "/home/project/output.tar.gz" "/home/project/transformed.txt"',
    dag = dag
)

# now define the order of tasks

download_task >> extract_task >> transform_task >> load_task
