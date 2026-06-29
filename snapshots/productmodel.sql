{% snapshot productmodel_snapshot %}

{{
    config(
      target_schema='snapshots',
      invalidate_hard_deletes=True,
      unique_key='ProductModelID',
      strategy='check',
      check_cols='all',
      location_root='abfss://silver@medallionsa01.dfs.core.windows.net/snapshots/'
    )
}}

with product_snapshot as (
    SELECT
        ProductModelID,
        Name,
        CatalogDescription
    FROM {{ source('saleslt', 'productmodel') }}
)
select * from product_snapshot

{% endsnapshot %}