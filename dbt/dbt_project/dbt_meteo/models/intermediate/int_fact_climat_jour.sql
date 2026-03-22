with stg_meto as (
    select m.*
    from {{ ref('stg_comores__meteo') }} as m
),
geocoded as (
    select g.*
    from {{ ref('villes_geocoded') }} as g
),
joined as (
    select 
        m.*,
        g.latitude, g.longitude
    from stg_meto as m
    left join geocoded as g
    on m.ville = g.ville

),
meteo_daily as (
    select 
        {{ dbt_utils.generate_surrogate_key(['date_jour', 'ville', 'island']) }} as meteo_jour_id,

        date_jour as date, ville, island,

        avg(temperature_2m) as temperature_2m,
        max(temperature_2m) as temperature_2m_max,
        min(temperature_2m) as temperature_2m_min,

        avg(apparent_temperature) as apparent_temperature,
        max(apparent_temperature) as apparent_temperature_max,
        min(apparent_temperature) as apparent_temperature_min,

        avg(dew_point_2m) as dew_point_2m,
        max(dew_point_2m) as dew_point_2m_max,
        min(dew_point_2m) as dew_point_2m_min,

        avg(relative_humidity_2m) as relative_humidity_2m,
        max(relative_humidity_2m) as relative_humidity_2m_max,
        min(relative_humidity_2m) as relative_humidity_2m_min,

        avg(vapour_pressure_deficit) as vapour_pressure_deficit,
        max(vapour_pressure_deficit) as vapour_pressure_deficit_max,
        min(vapour_pressure_deficit) as vapour_pressure_deficit_min,

        avg(wind_speed_10m) as wind_speed_10m,
        max(wind_speed_10m) as wind_speed_10m_max,
        min(wind_speed_10m) as wind_speed_10m_min,

        avg(wind_gusts_10m) as wind_gusts_10m,
        max(wind_gusts_10m) as wind_gusts_10m_max,
        min(wind_gusts_10m) as wind_gusts_10m_min,

        avg(cloud_cover) as cloud_cover,
        max(cloud_cover) as cloud_cover_max,
        min(cloud_cover) as cloud_cover_min,    

        avg(cloud_cover_low) as cloud_cover_low,
        max(cloud_cover_low) as cloud_cover_low_max,
        min(cloud_cover_low) as cloud_cover_low_min,

        avg(cloud_cover_mid) as cloud_cover_mid,
        max(cloud_cover_mid) as cloud_cover_mid_max,
        min(cloud_cover_mid) as cloud_cover_mid_min,

        avg(cloud_cover_high) as cloud_cover_high,
        max(cloud_cover_high) as cloud_cover_high_max,
        min(cloud_cover_high) as cloud_cover_high_min,  

        avg(visibility) as visibility,
        max(visibility) as visibility_max,
        min(visibility) as visibility_min,

        avg(pressure_msl) as pressure_msl,
        max(pressure_msl) as pressure_msl_max,
        min(pressure_msl) as pressure_msl_min,

        avg(surface_pressure) as surface_pressure,
        max(surface_pressure) as surface_pressure_max,
        min(surface_pressure) as surface_pressure_min,

        sum(precipitation) as precipitation,
        max(precipitation) as precipitation_max,

        sum(rain) as rain,
        max(rain) as rain_max,

        sum(showers) as showers,
        max(showers) as showers_max,

        sum(evapotranspiration) as evapotranspiration,
        avg(evapotranspiration) as evapotranspiration_avg,

        sum(et0_fao_evapotranspiration) as et0_fao_evapotranspiration,
        avg(et0_fao_evapotranspiration) as et0_fao_evapotranspiration_avg,

        mode(weather_code) as weather_code_simple,
        mode(wind_direction_10m) as wind_direction_10m_simple,
        latitude, longitude, grille_meteo
    from joined
    group by 
        date_jour, 
        ville, 
        island, 
        latitude, 
        longitude, 
        grille_meteo


)

select * from meteo_daily

