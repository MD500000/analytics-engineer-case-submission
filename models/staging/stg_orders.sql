{{ config(materialized='view') }}


-- Flag when delivered carrier date > delivered customer date

select
  order_id,
  customer_id,
  order_status,
  cast(order_purchase_timestamp as timestamp) as order_purchase_timestamp,
  cast(order_approved_at as timestamp) as order_approved_at,
  cast(order_delivered_carrier_date as timestamp) as order_delivered_carrier_date,
  cast(order_delivered_customer_date as timestamp) as order_delivered_customer_date,
  cast(order_estimated_delivery_date as timestamp) as order_estimated_delivery_date,
  case
    when order_delivered_carrier_date > order_delivered_customer_date then 1 else 0
  end as has_invalid_delivery_dates
from {{ ref('olist_orders_dataset') }}
