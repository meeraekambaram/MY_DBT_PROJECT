# my_dbt_project — Setup Guide (SQL-only friendly)

## What's in here
```
my_dbt_project/
├── dbt_project.yml              # project config (leave as-is)
├── profiles.yml                 # YOUR Snowflake login details (edit this)
└── models/
    ├── staging/
    │   ├── sources.yml          # points to your raw DEMO.PUBLIC.CS table
    │   └── stg_employee.sql     # clean SELECT from that raw table
    └── marts/
        └── dept_avg_salary.sql  # example: avg salary by department
```

## Step 1 — Install dbt (one-time, in a terminal)
```bash
pip install dbt-snowflake
```

## Step 2 — Put profiles.yml in the right place
dbt looks for connection details in `~/.dbt/profiles.yml`, NOT inside the project folder.

```bash
mkdir -p ~/.dbt
mv profiles.yml ~/.dbt/profiles.yml
```

## Step 3 — Edit ~/.dbt/profiles.yml with YOUR real values
Open it and replace the placeholders:

| Field | Where to find it |
|---|---|
| `account` | In your Snowflake URL: `https://<account>.snowflakecomputing.com` |
| `user` | Your Snowflake username |
| `password` | Your Snowflake password |
| `role` | Usually `SYSADMIN` or `ACCOUNTADMIN` — check in Snowflake UI top-right |
| `warehouse` | e.g. `COMPUTE_WH` — check under Admin > Warehouses |
| `database` | Already set to `DEMO` |
| `schema` | Schema dbt will BUILD new models into (can be `PUBLIC`) |

## Step 4 — Check the raw table's actual schema
Run this in Snowflake to confirm where `CS` really lives:
```sql
select table_catalog, table_schema, table_name
from DEMO.information_schema.tables
where table_name = 'CS';
```
If `table_schema` isn't `PUBLIC`, update it in `models/staging/sources.yml` too.

## Step 5 — Test the connection
```bash
cd my_dbt_project
dbt debug
```
You want to see "All checks passed!" at the bottom.

## Step 6 — Run it
```bash
dbt run
```
This creates `stg_employee` (a view) and `dept_avg_salary` (a table) in your Snowflake schema.

## Step 7 — See the results
```sql
select * from DEMO.PUBLIC.stg_employee;
select * from DEMO.PUBLIC.dept_avg_salary;
```

---
### Cheatsheet for what you'll actually touch day-to-day
- New raw table to use? → add it under `sources.yml`
- New SELECT you want as a table/view? → new `.sql` file in `models/`
- Referencing a raw table → `{{ source('demo', 'table_name') }}`
- Referencing another dbt model → `{{ ref('model_name') }}`
- Run everything → `dbt run`
