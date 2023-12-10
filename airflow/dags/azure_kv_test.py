from datetime import datetime, timedelta
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from textwrap import dedent
from airflow.models import Variable, Connection
from airflow import DAG
import logging
from airflow.utils.log.secrets_masker import mask_secret

from airflow import settings
settings.MASK_SECRETS_IN_LOGS = True

def get_value():
    variable_value = Variable.get("az-secret")
    # mask_secret(variable_value)
    return variable_value

def retrieve_variable_from_akv(value):
    variable_value = get_value()
    logger = logging.getLogger(__name__)
    logger.info(f"{variable_value}, {value}")

with DAG(
   "tutorial",
   default_args={
       "depends_on_past": False,
       "email": ["airflow@example.com"],
       "email_on_failure": False,
       "email_on_retry": False,
       "retries": 1,
       "retry_delay": timedelta(minutes=5),
    },
   description="This DAG shows how to use Azure Key Vault to retrieve variables in Apache Airflow DAG",
   schedule_interval=timedelta(days=1),
   start_date=datetime(2021, 1, 1),
   catchup=False,
   tags=["example"],
) as dag:

    get_variable_task = PythonOperator(
        task_id="get_variable",
        python_callable=retrieve_variable_from_akv,
        op_args=["secret"]
    )

    complete = BashOperator(
         task_id="complete",
         bash_command=" echo 'SUCCESS'"
         )
    get_variable_task >> complete