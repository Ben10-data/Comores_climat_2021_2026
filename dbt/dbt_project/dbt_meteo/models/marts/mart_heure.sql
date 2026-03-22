with meteo_mart_heure as (

    select *
    from {{ ref('int_fact_climat_heure') }}

)

select * from meteo_mart_heure