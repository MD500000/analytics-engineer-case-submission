{{ config(materialized='view') }}

-- Take most popular zip code prefix stats

with deduplicated as (
    select *
    from (
        select *,
            row_number() over (
                partition by geolocation_zip_code_prefix
                order by geolocation_lat, geolocation_lng
            ) as rn
        from {{ ref('olist_geolocation_dataset') }}
    ) t
    where rn = 1
)

select
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
from deduplicated
