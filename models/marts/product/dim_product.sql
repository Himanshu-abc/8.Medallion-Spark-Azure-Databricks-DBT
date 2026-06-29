{{
    config(
        materialized='table',
        location_root='abfss://gold@medallionsa01.dfs.core.windows.net/marts/'
    )
}}

with product_current as (

    select *
    from {{ ref('product_snapshot') }}
    where dbt_valid_to is null

),

category_current as (

    select *
    from {{ ref('productcategory_snapshot') }}
    where dbt_valid_to is null

)

select
    {{ dbt_utils.generate_surrogate_key(['p.ProductID']) }} as product_key,
    p.ProductID,
    p.Name as product_name,
    p.ProductNumber,
    p.Color,
    p.StandardCost,
    p.ListPrice,
    p.Size,
    p.Weight,
    c.Name as product_category,
    p.SellStartDate,
    p.SellEndDate,
    current_timestamp() as gold_loaded_at
from product_current p
left join category_current c
    on p.ProductCategoryID = c.ProductCategoryID