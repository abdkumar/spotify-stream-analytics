6. https://learn.microsoft.com/en-us/azure/databricks/delta/delta-change-data-feed
7. http://mamykin.com/posts/fast-data-load-snowflake-dbt/
8. using stream for multi table insert https://docs.snowflake.com/en/sql-reference/sql/insert-multi-table
9. dbt insert only https://github.com/dbt-labs/dbt-core/issues/6320
airflow installation refer: https://levelup.gitconnected.com/how-to-install-apache-airflow-with-docker-7902be3301b8


set snowflake username, password as environment variables

settings azure keyvault secrets backend
https://learn.microsoft.com/en-us/azure/data-factory/enable-azure-key-vault-for-managed-airflow

optimal use of secret manager
https://medium.com/apache-airflow/setting-up-aws-secrets-backends-with-airflow-in-a-cost-effective-way-dac2d2c43f13


top level code issues in airflow
https://medium.com/apache-airflow/avoiding-the-pitfalls-of-top-level-dag-code-fa480d9e75c6

caching of variables
https://marclamberti.com/blog/variables-with-apache-airflow/


combining taskflow api and traditional airflow task definition
https://medium.com/apache-airflow/unleashing-the-power-of-taskflow-api-in-apache-airflow-371637089141

# Orchestrating Databricks JOb
https://docs.databricks.com/en/workflows/jobs/how-to/use-airflow-with-jobs.html

export AIRFLOW_CONN_DATABRICKS_DEFAULT='databricks://@host-url?token=yourtoken'


# Issues Faced
- docker api 6.3.1 was using urllib3 v2 2.3.0 which is causing the issue (API version not found)
 use docker api 7.0.0 https://github.com/docker/docker-py/blob/main/requirements.txt

- 

using light weight airflow
https://medium.com/@alexroperez4/docker-airflow-gcp-80ef9280fbd3



