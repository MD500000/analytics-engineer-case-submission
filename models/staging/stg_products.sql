{{ config(materialized='view') }}

select
  product_id,
  coalesce(product_category_name, 'Other') as product_category_name,
  coalesce(product_name_lenght, 0) as product_name_length,
  coalesce(product_description_lenght, 0) as product_description_length,
  coalesce(product_photos_qty, 0) as product_photos_qty,
  coalesce(product_weight_g, 0) as product_weight_g,
  coalesce(product_length_cm, 0) as product_length_cm,
  coalesce(product_height_cm, 0) as product_height_cm,
  coalesce(product_width_cm, 0) as product_width_cm,
  case
    when coalesce(product_weight_g, 0) = 0
      or coalesce(product_length_cm, 0) = 0
      or coalesce(product_height_cm, 0) = 0
      or coalesce(product_width_cm, 0) = 0
    then 1 else 0
  end as has_invalid_dimensions
from {{ ref('olist_products_dataset') }}
