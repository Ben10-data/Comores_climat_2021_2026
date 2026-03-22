with meteo_mart_jour as (

    select *
    from {{ ref('int_fact_climat_jour') }}

)

select * from meteo_mart_jour