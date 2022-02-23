{{ config(materialized='table') }}

with fhv_trip as (
    select *
    from {{ ref('stg_fhv_tripdata') }}
), 

dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select 
    tripid, 
    dispatching_base_num,
    pickup_datetime,
    dropoff_datetime,
    PULocationID,
    DOLocationID,
    SR_Flag,
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,  
from fhv_trip
    inner join dim_zones as pickup_zone
on fhv_trip.PULocationID = pickup_zone.locationid
    inner join dim_zones as dropoff_zone
on fhv_trip.DOLocationID = dropoff_zone.locationid