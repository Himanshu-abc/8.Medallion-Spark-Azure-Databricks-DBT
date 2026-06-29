{% snapshot productdescription_snapshot %}

{{
    config(
      target_schema='snapshots',
      invalidate_hard_deletes=True,
      unique_key='ProductDescriptionID',
      strategy='check',
      check_cols='all',
      location_root='abfss://silver@medallionsa01.dfs.core.windows.net/snapshots/'
    )
}}

with source_data as (
    select
        ProductDescriptionID,
        Description,
        rowguid,
        ModifiedDate
    from {{ source('saleslt', 'productdescription') }}
)
select *
from source_data

{% endsnapshot %}