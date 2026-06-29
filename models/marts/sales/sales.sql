{{
    config(
        materialized='table',
        location_root='abfss://gold@medallionsa01.dfs.core.windows.net/marts/'
    )
}}

with sales_header as (

    select *
    from {{ ref('salesorderheader_snapshot') }}
    where dbt_valid_to is null

),

sales_detail as (

    select *
    from {{ ref('salesorderdetail_snapshot') }}
    where dbt_valid_to is null

)

select
    h.SalesOrderID,
    h.OrderDate,
    h.DueDate,
    h.ShipDate,
    h.Status,
    h.OnlineOrderFlag,
    h.CustomerID,
    d.SalesOrderDetailID,
    d.ProductID,
    d.OrderQty,
    d.UnitPrice,
    d.UnitPriceDiscount,
    d.LineTotal,
    h.SubTotal,
    h.TaxAmt,
    h.Freight,
    h.TotalDue,
    current_timestamp() as gold_loaded_at
from sales_header h
inner join sales_detail d
    on h.SalesOrderID = d.SalesOrderID