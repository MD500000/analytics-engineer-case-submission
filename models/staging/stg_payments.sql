{{ config(materialized='view') }}

select
  order_id,
  payment_sequential,
  payment_type,
  payment_installments,
  payment_value

from {{ ref('olist_order_payments_dataset') }}
