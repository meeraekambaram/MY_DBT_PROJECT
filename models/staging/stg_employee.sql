select
    id,
    name,
    department,
    city,
    salary
from {{ source('demo', 'cs') }}
