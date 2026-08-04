select
    department,
    count(*) as headcount,
    avg(salary) as avg_salary
from {{ ref('stg_employee') }}
group by department
