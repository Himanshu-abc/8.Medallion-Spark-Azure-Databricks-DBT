{% snapshot customer_snapshot %}

{{
    config(
      target_schema='snapshots',
      invalidate_hard_deletes=True,
      unique_key='CustomerId',
      strategy='check',
      check_cols='all',
      location_root='abfss://silver@medallionsa01.dfs.core.windows.net/snapshots/'
    )
}}

with source_data as (
    select
        CustomerId,
        NameStyle,
        Title,
        FirstName,
        MiddleName,
        LastName,
        Suffix,
        CompanyName,
        SalesPerson,
        EmailAddress,
        Phone,
        PasswordHash,
        PasswordSalt
    from {{ source('saleslt', 'customer') }}
)
select *
from source_data

{% endsnapshot %}