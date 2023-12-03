1. create snowflake account
2. create database, schema and staging table
3. create a role called staging_role (for cdc), dev_role (for dbt transformations)
4. give access on database, schema, table to role staging_role, dev_role
5. give compute access to staging_role, dev_role