with meteo_mart_mois as (
    select * 
    from {{ ref('int_fact_climat_mois') }}
)

select * from meteo_mart_mois