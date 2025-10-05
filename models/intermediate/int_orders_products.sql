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

order_items as (
    select
        order_id,
        order_item_id,
        product_id,
        price,
        freight_value
    from {{ ref('stg_orders_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
)

select
    o.order_id,
    o.customer_id,
    oi.product_id,
    oi.price,
    oi.freight_value,
    oi.order_item_id,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    p.product_photos_qty
from orders o
join order_items oi
    on o.order_id = oi.order_id
left join products p
    on oi.product_id = p.product_id
where p.product_weight_g > 0
  and p.product_length_cm > 0
  and p.product_height_cm > 0
  and p.product_width_cm > 0
