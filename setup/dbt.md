# Setup DBT (Data Build Tool)
`dbt` is an ELT (Extract Load Transform) tool which allows us to efficiently and reliably build and manage data models, ensuring data quality and consistency. Through SQL-based transformations and modular code structure, dbt promotes collaboration and facilitates seamless integration with your existing data pipeline.

![](https://github.com/dbt-labs/dbt-core/raw/202cb7e51e218c7b29eb3b11ad058bd56b7739de/etc/dbt-transform.png)
Image Reference: https://github.com/dbt-labs/dbt-core

dbt is available as opensource also a managed service

- `dbt Core`: a set of open source Python packages, run via the command line, that helps you transform, document, and test your data
- `dbt Cloud`: a web based UI that allows you to both develop, deploy and schedule data pipelines (built on top of dbt Core)

you can try creating account [dbt cloud](https://www.getdbt.com/signup) and explore

![Alt text](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*8L_uabQtLvGmG51CRMeboQ.png)

# Installation

Install dbt core using pip

```
python -m pip install dbt-core
python -m pip install dbt-snowflake
```

if you want to install all the adapters
```
python -m pip install \
  dbt-core \
  dbt-postgres \
  dbt-redshift \
  dbt-snowflake \
  dbt-bigquery \
  dbt-trino
```

# Configuring Snowflake Profile
The profiles.yml file should contain the required variables for connecting to your Snowflake warehouse.
Ensure the following variables are defined within the "spotify" profile:

we are orchestration the dbt transforamtions using airflow DAG's so add these varaibles as secrets in Keyvault

- sfAccount: Snowflake account URL
- sfuser: Snowflake warehouse username 
- sfPassword: Snowflake warehouse password
- sfDatabase: Snowflake database name
- sfSchema: Snowflake schema name
- sfDbtRole: Snowflake role with proper grants (dev_role in our case)
- sfWarehouse: Snowflake warehouse name

**[check snowflake configuration](https://github.com/abdkumar/spotify-stream-analytics/blob/main/setup/snowflake.md)**

To run dbt locally, you have two options:
- Hardcode the variables in profiles.yml: Edit the profiles.yml file and directly replace the placeholder values with your actual credentials.
- Set environment variables: Set environment variables for each connection parameter (e.g., export SF_PASSWORD=your_password).


# Setting credentials of the adapter
If you're using dbt Core, you'll need a profiles.yml file that contains the connection details for your data platform. When you run dbt Core from the command line, it reads your dbt_project.yml file to find the profile name, and then looks for a profile with the same name in your profiles.yml file. This profile contains all the information dbt needs to connect to your data platform.

by default profile.yml will be freated in the directory `C:\Users\<username>\.dbt`. Make sure to set the right profile in project.yml 

Run debug command to check the chosen data platform connection
```bash
dbt debug
``` 

If the profiles.yml is added in current working directory then  run
```bash
dbt debug --profiles-dir=.
```

# Orchestrating dbt models through airflow
There are 2 ways in which we can orchestrate dbt models for the Spotify project using Airflow.

### Bruteforce Approach:
Copying the dbt project directly into the Airflow DAGs directory is discouraged. This clutters the directory and makes maintenance cumbersome.

### Recommended Approach:
**1. Dockerize your dbt project:**
- We've created a Dockerfile within the dbt folder to containerize the dbt environment.
- Build the Docker image using:

**2. Orchestrate with Airflow DockerOperator:**
- Create an Airflow DAG with a DockerOperator task.
- Specify the spotify-dbt:latest image in the operator.
- Mount the dbt project directory (e.g., ~/spotify-stream-analytics/dbt) as a volume within the container.
- Pass environment variables containing sensitive information (e.g., passwords) at runtime using the env parameter in the `DockerOperator`.

```bash
cd ~/spotify-stream-analytics/dbt
docker build -t spotify-dbt:latest .
```

# Running dbt models standalone
Models are where your developers spend most of their time within a dbt environment. Models are primarily written as a select statement and saved as a .sql file. While the definition is straightforward, the complexity of the execution will vary from environment to environment. Models will be written and rewritten as needs evolve and your organization finds new ways to maximize efficiency.

you can add your transformation files in models directory

we can add test cases in schema.yml file inside models directory for data quality check
Read more about [dbt tests](https://docs.getdbt.com/docs/build/tests)
```
dbt test
```

[dbt run](https://docs.getdbt.com/reference/commands/run) executes compiled sql model files against the current target database. dbt connects to the target database and runs the relevant SQL required to materialize all data models using the specified materialization strategies. Models are run in the order defined by the dependency graph generated during compilation. Intelligent multi-threading is used to minimize execution time without violating dependencies.
```
dbt run
```

you can also copy profiles.yml file to current woring directory and run dbt models

```
dbt run --profiles-dir=.
```

if we want to run only specific model

```
dbt run --profiles-dir=. --select dim_dates
```

#### Read more about dbt: https://docs.getdbt.com/docs/introduction