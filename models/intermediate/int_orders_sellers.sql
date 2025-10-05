{{ config(materialized='table') }}

with orders as (
    select
        order_id,
        order_purchase_timestamp,
        order_delivered_customer_date,
        order_status
    from {{ ref('stg_orders') }}
    where order_status in ('delivered')
      and order_delivered_customer_date is not null
      and order_purchase_timestamp is not null
),

order_items as (
    select
        order_id,
        seller_id,
        product_id,
        price,
        freight_value
    from {{ ref('stg_orders_items') }}
),

sellers as (
    select
        seller_id
    from {{ ref('stg_sellers') }}
)

select
    oi.seller_id,
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    oi.freight_value,
    oi.price,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date
from order_items oi
join orders o
    on oi.order_id = o.order_id
left join sellers s
    on oi.seller_id = s.seller_id
