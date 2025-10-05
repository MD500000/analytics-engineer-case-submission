-- Checking if products are within reasonable dimensions

select *
from {{ ref('fct_product_performance') }}
where avg_product_weight_g > 50000
   or avg_product_length_cm > 500
   or avg_product_height_cm > 500
   or avg_product_width_cm > 500
   or avg_photos_per_product > 50