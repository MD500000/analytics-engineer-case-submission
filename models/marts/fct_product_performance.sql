{{ config(materialized='table') }}

with product_base as (
    select * from {{ ref('int_orders_products') }} oi
),

product_metrics as (
    select
        -- Primary key
        product_id,
        
        -- Time period for trend analysis
        date_trunc('month', order_purchase_timestamp) as performance_month,
                
        -- Sales Volume Metrics
        count(distinct order_id) as total_orders,
        count(distinct order_item_id) as total_items_sold,
        
        -- Revenue Metrics
        sum(price) as total_revenue,
        avg(price) as avg_sale_price,
        min(price) as min_sale_price,
        max(price) as max_sale_price,
        
        -- Freight Metrics
        sum(freight_value) as total_freight_cost,
        avg(freight_value) as avg_freight_per_item,
        
        -- Product Popularity Metrics
        count(distinct customer_id) as unique_customers,
        
        -- Product Physical Metrics (Averages)
        avg(product_weight_g) as avg_product_weight_g,
        avg(product_length_cm) as avg_product_length_cm,
        avg(product_height_cm) as avg_product_height_cm,
        avg(product_width_cm) as avg_product_width_cm,
        avg(product_photos_qty) as avg_photos_per_product,
                
        -- Revenue Efficiency
        sum(price) / nullif(count(distinct order_item_id), 0) as revenue_per_item,
        sum(price) / nullif(avg(product_weight_g), 0) as revenue_per_gram,

    from product_base
    group by product_id, date_trunc('month', order_purchase_timestamp)
)

select 
    *
from product_metrics
order by performance_month desc, total_revenue desc