-- Checking that no order have their carrier date be longer than the customer delivered date

select *
from {{ ref('stg_orders') }}
where order_delivered_carrier_date > order_delivered_customer_date
and has_invalid_delivery_dates = 0
