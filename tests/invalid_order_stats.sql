-- Checking that no orders have invalid stats

select *
from {{ ref('fct_orders_stats') }}
where num_items <= 0 or num_products <= 0 or total_price <= 0 or avg_price <= 0