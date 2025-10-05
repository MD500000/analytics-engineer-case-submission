{{ config(materialized='table') }}

with seller_orders as (
    select *
    from {{ ref('int_orders_sellers') }}
),

-- Aggregate metrics per seller
seller_fulfillment as (
    select
        seller_id,
        
        -- Number of orders handled
        count(distinct order_id) as total_orders,
        
        -- Revenue and freight
        sum(price) as total_revenue,
        sum(freight_value) as total_freight,
        avg(price) as avg_price_per_order,
        avg(freight_value) as avg_freight_per_order,
        
        -- Delivery performance metrics
        avg(date_diff('day', order_purchase_timestamp, order_delivered_customer_date)) as avg_delivery_days,
        min(date_diff('day', order_purchase_timestamp, order_delivered_customer_date)) as min_delivery_days,
        max(date_diff('day', order_purchase_timestamp, order_delivered_customer_date)) as max_delivery_days,
        coalesce(stddev(date_diff('day', order_purchase_timestamp, order_delivered_customer_date)), 0) as delivery_days_stddev
        
    from seller_orders
    group by seller_id
)

select *
from seller_fulfillment
order by avg_delivery_days asc
