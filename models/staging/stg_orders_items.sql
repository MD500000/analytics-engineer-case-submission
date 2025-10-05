{{ config(materialized='view') }}

select
  order_id,
  order_item_id,
  product_id,
  seller_id,
  CAST(shipping_limit_date AS TIMESTAMP) as shipping_limit_date,
  price,
  freight_value

from {{ ref('olist_order_items_dataset') }}
