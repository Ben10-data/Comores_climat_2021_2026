with dim_weather as (

    select distinct
        {{ dbt_utils.generate_surrogate_key(['weather_code_clean']) }} as weather_id,
        weather_code_clean as weather_code

    from {{ ref('int_fact_climat_heure') }}

), 

weather_description as (
    select 
        weather_id,
        weather_code, 
        case 
            when weather_code = 0 then 'ciel clair'
            when weather_code between 1 and 4 then 'partiellement nuageux'
            when weather_code between 45 and 48 then 'brouillard'
            when weather_code between 51 and 57 then 'pluie fine'
            when weather_code between 61 and 67 then 'pluie modérée à forte'
            when weather_code between 71 and 77 then 'neige fine'
            when weather_code between 80 and 86 then 'averses de pluie'
            when weather_code between 95 and 99 then 'orage'
            else 'inconnu'
        end as weather_description
    from dim_weather
           
)

select * from weather_description