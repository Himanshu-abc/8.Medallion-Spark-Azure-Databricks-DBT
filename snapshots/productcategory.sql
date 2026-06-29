{% snapshot productcategory_snapshot %}

{{
    config(
      target_schema='snapshots',
      invalidate_hard_deletes=True,
      unique_key='ProductCategoryID',
      strategy='check',
      check_cols='all'
    )
}}

with source_data as (
    select
        ProductCategoryID,
        ParentProductCategoryID,
        Name,
        rowguid,
        ModifiedDate
    from {{ source('saleslt', 'productcategory') }}
)
select *
from source_data

{% endsnapshot %}