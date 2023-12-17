from airflow import DAG
from datetime import datetime
from airflow.models import Variable
from airflow.operators.dummy import DummyOperator
from airflow.providers.databricks.operators.databricks import DatabricksRunNowOperator
from airflow.providers.docker.operators.docker import DockerOperator

# snowflake configuration
KEYVAULT_SNOWFLAKE_ACCOUNT_SECRET = "sfAccount"
KEYVAULT_SNOWFLAKE_USERNAME_SECRET = "sfUser"
KEYVAULT_SNOWFLAKE_PASSWORD_SECRET = "sfPassword"
KEYVAULT_SNOWFLAKE_ROLE_SECRET = "sfDbtRole"
KEYVAULT_SNOWFLAKE_DATABASE_SECRET = "sfDatabase"
KEYVAULT_SNOWFLAKE_SCHEMA_SECRET = "sfSchema"
KEYVAULT_SNOWFLAKE_WAREHOUSE_SECRET = "sfWarehouse"

# databricks configuration
DATABRICKS_CONN_ID = "databricks-secret"
DATABRICKS_JOB_SECRET = "databricksJobID"

def get_env_variables() -> dict:
    # create mappings
    mappings = {
        "SNOWFLAKE_ACCOUNT": KEYVAULT_SNOWFLAKE_ACCOUNT_SECRET,
        "SNOWFLAKE_USERNAME": KEYVAULT_SNOWFLAKE_USERNAME_SECRET,
        "SNOWFLAKE_PASSWORD": KEYVAULT_SNOWFLAKE_PASSWORD_SECRET,
        "SNOWFLAKE_ROLE": KEYVAULT_SNOWFLAKE_ROLE_SECRET,
        "SNOWFLAKE_DATABASE": KEYVAULT_SNOWFLAKE_DATABASE_SECRET,
        "SNOWFLAKE_SCHEMA": KEYVAULT_SNOWFLAKE_SCHEMA_SECRET,
        "SNOWFLAKE_WAREHOUSE": KEYVAULT_SNOWFLAKE_WAREHOUSE_SECRET,
    }
    return {
        key: Variable.get(value) for key, value in mappings.items()
    }
    
with DAG(
    dag_id="cdc_snowflake",
    start_date=datetime(2023, 12, 10),
    schedule="@hourly",
    catchup=False,
    tags=["test"],
) as dag:
    
    start = DummyOperator(
        task_id='start'
    )
    
    # Create a DatabricksRunNowOperator instance
    run_databricks = DatabricksRunNowOperator(
        task_id="trigger_databricks_job",
        job_id=Variable.get(DATABRICKS_JOB_SECRET),
        databricks_conn_id=DATABRICKS_CONN_ID,
        deferrable=True
    )
    

    run_dbt = DockerOperator(
        task_id="trigger_dbt_transformations",
        image="spotify-dbt:latest",
        container_name="dbt_container",
        command=["/bin/sh", "-c", "cd spotify_project && dbt deps && dbt run --profiles-dir=."],
        api_version="auto",
        auto_remove=True,
        environment=get_env_variables(),
        network_mode="bridge",
        docker_url="tcp://docker-socket-proxy:2375",
    )
    
    end = DummyOperator(
        task_id='end'
    )
    
    
    start >> run_databricks >> run_dbt >> end
    
