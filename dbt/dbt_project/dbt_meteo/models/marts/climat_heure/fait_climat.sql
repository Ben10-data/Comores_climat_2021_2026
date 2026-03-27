SELECT 
    d.temps_id AS date_id,
    l.localisation_id AS localisation_id,
    w.weather_id AS weather_id,

    m.temperature_2m,
    m.apparent_temperature,

    m.relative_humidity_2m,
    m.dew_point_2m,

    m.precipitation,
    m.rain,

    m.wind_speed_10m,
    m.wind_direction_10m,

    m.cloud_cover,
    m.cloud_cover_low,
    m.cloud_cover_mid,
    m.cloud_cover_high,
    m.pressure_msl,
    m.surface_pressure,
    m.visibility,
    m.showers,
    
    case 
        when m.precipitation = 0 and m.cloud_cover < 20 then 'ensoleillé'
        when m.precipitation > 0 then 'pluvieux'
        else 'nuageux'
    end as weather_category

FROM {{ ref('int_pour_mart_heure') }} AS m 

LEFT JOIN {{ ref('dim_localisation') }} AS l
    ON m.ville = l.ville 
   AND m.island = l.island

LEFT JOIN {{ ref('dim_temps') }} AS d
    ON m.date_heure = d.date_heure  

LEFT JOIN {{ ref('dim_weather') }} AS w
    ON m.weather_code_clean = w.weather_code