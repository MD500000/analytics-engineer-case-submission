-- Checking that no order counts are below 0 or lifetime value/distinct sellers / products purchased

select *
from {{ ref('fct_customers_products') }}
where total_orders_count <= 0 or lifetime_total_value <= 0 or distinct_sellers_used <= 0 or distinct_products_purchased <= 0