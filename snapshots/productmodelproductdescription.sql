{% snapshot productmodelproductdescription_snapshot %}

{{
    config(
      target_schema='snapshots',
      invalidate_hard_deletes=True,
      unique_key= dbt_utils.generate_surrogate_key(['ProductModelID', 'ProductDescriptionID']),
      strategy='check',
      check_cols='all'
    )
}}

with source_data as (
    select
        ProductModelID,
        ProductDescriptionID,
        Culture,
        rowguid,
        ModifiedDate
    from {{ source('saleslt', 'productmodelproductdescription') }}
)
select *
from source_data

{% endsnapshot %}