{{
    config(
        materialized='table',
        location_root='abfss://gold@medallionsa01.dfs.core.windows.net/marts/'
    )
}}

with customer_current as (

    select *
    from {{ ref('customer_snapshot') }}
    where dbt_valid_to is null

)

select
    {{ dbt_utils.generate_surrogate_key(['CustomerId']) }} as customer_key,
    CustomerId,
    Title,
    FirstName,
    MiddleName,
    LastName,
    concat_ws(' ', Title, FirstName, MiddleName, LastName) as full_name,
    CompanyName,
    EmailAddress,
    Phone,
    current_timestamp() as gold_loaded_at
from customer_current