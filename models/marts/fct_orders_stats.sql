{{ config(materialized='table') }}

with order_aggregates as (
    select
        order_id,
        customer_id,
        COUNT(*) as num_items,
        COUNT(distinct product_id) as num_products,
        SUM(price) as total_price,
        SUM(freight_value) as total_freight,
        AVG(price) as avg_price,
        AVG(freight_value) as avg_freight,
        CASE WHEN SUM(price) > 100 THEN 1 ELSE 0 END as high_value_order_flag,
        SUM(price) / COUNT(*) as price_per_item,
        SUM(freight_value) / SUM(price) as freight_ratio
    from {{ ref('int_orders_customers') }}
    group by order_id, customer_id
)

select *
from order_aggregates
    