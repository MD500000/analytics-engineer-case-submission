{{ config(materialized='table') }}

select 
    customer_unique_id,
    
    -- Customer lifetime metrics
    count(distinct order_id) as total_orders_count,
    sum(price) as lifetime_total_value,
    sum(freight_value) as lifetime_freight_value,
    sum(payment_value) as lifetime_payment_value,
    
    -- Product engagement
    count(distinct product_id) as distinct_products_purchased,
    count(distinct seller_id) as distinct_sellers_used,
        
    -- Payment behavior
    avg(payment_installments) as avg_installments,
    max(payment_installments) as max_installments_used

from {{ ref('int_orders_customers') }}
group by customer_unique_id