{{ config(materialized='table') }}

-- Get most popular category per unique customer id

with orders as (
    select
        order_id,
        customer_id
    from {{ ref('stg_orders') }}
    where order_status not in ('canceled','unavailable')
      and order_delivered_customer_date is not null
      and order_purchase_timestamp is not null
),

order_items as (
    select
        order_id,
        product_id
    from {{ ref('stg_orders_items') }}
),

products as (
    select
        p.product_id,
        coalesce(t.product_category_name_english, p.product_category_name) as category
    from {{ ref('stg_products') }} p
    left join {{ ref('product_category_name_translation') }} t
        on p.product_category_name = t.product_category_name
),

customers as (
    select
        customer_id,
        customer_unique_id
    from {{ ref('stg_customers') }}
),

customer_category_counts as (
    select
        c.customer_unique_id,
        pr.category,
        count(*) as cnt,
        row_number() over (
            partition by c.customer_unique_id
            order by count(*) desc
        ) as rn
    from orders o
    join order_items oi on o.order_id = oi.order_id
    join products pr on oi.product_id = pr.product_id
    join customers c on o.customer_id = c.customer_id
    group by c.customer_unique_id, pr.category
)

select
    customer_unique_id,
    category as most_popular_category
from customer_category_counts
where rn = 1
