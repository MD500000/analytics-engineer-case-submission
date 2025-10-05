-- Checking if products that weren't already marked have invalid dimensions

select *
from {{ ref('stg_products') }}
where (
      product_weight_g <= 0
   or product_length_cm <= 0
   or product_height_cm <= 0
   or product_width_cm <= 0
)
and has_invalid_dimensions = 0
