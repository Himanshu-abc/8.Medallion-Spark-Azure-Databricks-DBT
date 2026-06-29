{% snapshot customeraddress_snapshot %}

{{
    config(
      target_schema='snapshots',
      invalidate_hard_deletes=True,
      unique_key= dbt_utils.generate_surrogate_key(['CustomerId', 'AddressId']),
      strategy='check',
      check_cols='all',
      location_root='abfss://silver@medallionsa01.dfs.core.windows.net/snapshots/'
    )
}}

with source_data as (
    select
        CustomerId,
        AddressId,
        AddressType
    from {{ source('saleslt', 'customeraddress') }}
)
select *
from source_data

{% endsnapshot %}