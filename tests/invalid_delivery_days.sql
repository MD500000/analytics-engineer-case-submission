-- Checking that no orders have delivery days of less than or equal to 0

select *
from {{ ref('fct_fulfillment_metrics') }}
where avg_delivery_days <= 0 or max_delivery_days <= 0