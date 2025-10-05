{{ config(materialized='table') }}

with customer_products as (
    select *
    from {{ ref('stg_products') }}
),

category_translation as (
    select *
    from {{ ref('stg_products_translations') }}
),

cleaned_products as (
    select
        cp.product_id,
        lower(cp.product_category_name) as product_category_name,
        ctn.product_category_name_english
    from customer_products cp
    left join category_translation ctn
        on cp.product_category_name = ctn.product_category_name
)

select *
from cleaned_products
