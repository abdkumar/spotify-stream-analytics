from airflow import DAG
from datetime import datetime
from airflow.providers.docker.operators.docker import DockerOperator


with DAG(
    dag_id="dbt_test",
    start_date=datetime(2023, 12, 10),
    schedule_interval=None,
) as dag:
    
    hello_world_task = DockerOperator(
        task_id="dbt_test",
        image="spotify-dbt:latest",
        container_name="dbt_container",
        command=["/bin/sh", "-c", "dbt deps && dbt debug"],
        api_version="auto",
        auto_remove=True,
        environment={
                'SNOWFLAKE_ACCOUNT': 'olbyglc-eoa82294',
                'SNOWFLAKE_PASSWORD': 'Abdkumar@1'},
        network_mode="bridge",
        docker_url='tcp://docker-socket-proxy:2375',
    )