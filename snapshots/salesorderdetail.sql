{% snapshot salesorderdetail_snapshot %}

{{
    config(
      target_schema='snapshots',
      invalidate_hard_deletes=True,
      unique_key='SalesOrderDetailID',
      strategy='check',
      check_cols='all',
      location_root='abfss://silver@medallionsa01.dfs.core.windows.net/snapshots/'
    )
}}

with salesorderdetail_snapshot as (
    SELECT
        SalesOrderID,
        SalesOrderDetailID,
        OrderQty,
        ProductID,
        UnitPrice,
        UnitPriceDiscount,
        LineTotal
    FROM {{ source('saleslt', 'salesorderdetail') }}
)
select * from salesorderdetail_snapshot

{% endsnapshot %}