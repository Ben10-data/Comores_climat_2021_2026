with source as (

    select *
    from {{ source('meteo_comores','METEO_PAR_HEURE') }}

), meteo_heure as (

    SELECT 
       {{ dbt_utils.generate_surrogate_key(['date', 'ville', 'island']) }} 
       as meteo_heure_id,
       
       date::TIMESTAMP_TZ as date_heure, date_heure::DATE as date_jour, date_heure::TIMESTAMP as heure,
        rain, temperature_2m, relative_humidity_2m,
       dew_point_2m, precipitation,
       wind_speed_10m, wind_direction_10m,
       wind_gusts_10m,
       cloud_cover, cloud_cover_low, cloud_cover_mid, cloud_cover_high,
       pressure_msl, surface_pressure, visibility, weather_code,
       apparent_temperature, evapotranspiration,
       et0_fao_evapotranspiration, vapour_pressure_deficit,ville, island, showers, grille_meteo
    
    FROM source 
)

select *
from meteo_heure 

