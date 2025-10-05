-- Checking that revenue and total orders are logical

select *
from {{ ref('fct_product_performance') }}
where total_orders > 0 and total_revenue = 0