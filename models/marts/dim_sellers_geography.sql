{{ config(materialized='table') }}

with sellers as (
    select * 
    from {{ ref('stg_sellers') }}
),

geolocation as (
    select * 
    from {{ ref('stg_geolocation') }}
),

cleaned_sellers as (
    select
        seller_id,
        seller_zip_code_prefix,
        lower(seller_city) as city,
        upper(seller_state) as state
    from sellers
)

select
    s.seller_id,
    s.city,
    s.state,
    s.seller_zip_code_prefix,

    -- Replace null lat/lng with 0
    coalesce(g.geolocation_lat, 0) as geolocation_lat,
    coalesce(g.geolocation_lng, 0) as geolocation_lng,

    -- Flag for missing geolocation metrics
    case 
        when g.geolocation_lat is null or g.geolocation_lng is null then 1
        else 0
    end as missing_geolocation_flag
    
from cleaned_sellers s
left join geolocation g
    on s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
