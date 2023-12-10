from airflow import DAG
from airflow.models.baseoperator import chain
from airflow.operators.dummy import DummyOperator
from airflow.providers.databricks.operators.databricks import DatabricksRunNowOperator
from pendulum import datetime


# airflow-connections-databricks-secret
DATABRICKS_JOB_ID = "718451519644857"
DATABRICKS_CONN_ID = "databricks-secret"

with DAG(
    dag_id="databricks_cdc_dag",
    schedule="@daily",
    start_date=datetime(2023, 1, 1),
    catchup=False,
    tags=["test"],
) as dag:
    
    start = DummyOperator(
        task_id='start'
    )
    
    # Create a DatabricksRunNowOperator instance
    databricks_operator = DatabricksRunNowOperator(
        task_id="trigger_databricks_job",
        job_id=DATABRICKS_JOB_ID,
        databricks_conn_id=DATABRICKS_CONN_ID,
        deferrable=True
    )
    
    end = DummyOperator(
        task_id='end'
    )
    # Set the task dependencies
    chain(start, databricks_operator, end)
