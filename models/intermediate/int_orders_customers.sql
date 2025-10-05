{{ config(materialized='table') }}

with orders as (
    select
        order_id,
        customer_id,
        order_purchase_timestamp,
        order_delivered_customer_date,
        order_status
    from {{ ref('stg_orders') }}
    where order_status not in ('canceled','unavailable')
      and order_delivered_customer_date is not null
      and order_purchase_timestamp is not null
),


payments as (
    select * from {{ ref('stg_payments') }}
),

order_items as (
    select
        order_id,
        price,
        freight_value,
        product_id,
        seller_id
    from {{ ref('stg_orders_items') }}
),

customers as (
    select
        customer_id,
        customer_unique_id
    from {{ ref('stg_customers') }}
)

select
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    oi.price,
    oi.freight_value,
    oi.product_id,
    oi.seller_id,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    coalesce(p.payment_sequential, 0) as payment_sequential,
    coalesce(p.payment_installments, 0) as payment_installments,
    coalesce(p.payment_value, 0) as payment_value
from orders o
join order_items oi
    on o.order_id = oi.order_id
left join customers c
    on o.customer_id = c.customer_id
left join payments p 
    on o.order_id = p.order_id
