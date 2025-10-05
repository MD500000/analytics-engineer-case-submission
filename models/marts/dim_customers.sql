{{ config(materialized='table') }}

with base as (
    select *
    from {{ ref('int_orders_customers') }}
),

customer_orders as (
    select
        customer_unique_id,
        min(order_purchase_timestamp) as first_order_date,
        max(order_purchase_timestamp) as last_order_date
    from base
    group by customer_unique_id
),

customer_products as (
    select * from {{ ref('int_customer_products') }}
)

select
    co.customer_unique_id,
    co.first_order_date,
    co.last_order_date,
    cp.most_popular_category
from customer_orders co
left join customer_products cp
    on co.customer_unique_id = cp.customer_unique_id
