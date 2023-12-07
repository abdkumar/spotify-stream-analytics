## Refer https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html
## curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.7.3/docker-compose.yaml'
## mkdir -p ./dags ./logs ./plugins ./config
## echo -e "AIRFLOW_UID=$(id -u)" > .env

cd ~/spotify-stream-analytics/airflow/

docker compose up airflow-init

docker compose up

