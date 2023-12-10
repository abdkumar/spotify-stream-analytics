from airflow import DAG
from datetime import datetime
from airflow.providers.docker.operators.docker import DockerOperator


with DAG(
    dag_id="hello_world",
    start_date=datetime(2023, 12, 10),
    schedule_interval=None,
) as dag:
    
    hello_world_task = DockerOperator(
        task_id="hello_world",
        image="hello-world:latest",
        command=["/bin/sh", "-c", "echo Hello World! && sleep 30"],
        docker_url="unix://var/run/docker.sock"
    )