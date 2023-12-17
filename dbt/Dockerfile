FROM python:3.10-slim

COPY ./spotify_project ./spotify_project

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git
    
RUN pip install dbt-core==1.7.3
RUN pip install dbt-snowflake==1.7.0

CMD ["dbt"]