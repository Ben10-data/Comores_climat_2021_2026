WITH base AS (

    SELECT 
        {{ dbt_utils.generate_surrogate_key(['d.date_mois_id','l.localisation_id']) }} AS fait_agriculture_id,

        d.date_mois_id AS date_id,
        l.localisation_id,
        w.weather_id,

        -- temperature
        m.temperature_2m,
        m.temperature_2m_min,
        m.temperature_2m_max,
        m.dew_point_2m,

        -- precipitation 
        m.precipitation,
        m.precipitation_max,

        -- pluie 
        m.rain,
        m.rain_max,
        m.showers,
        m.showers_max,

        -- evapotranspiration
        m.evapotranspiration,
        m.evapotranspiration_avg,
        m.et0_fao_evapotranspiration,

        -- stress hydrique 
        m.vapour_pressure_deficit,
        m.vapour_pressure_deficit_max,
        m.relative_humidity_2m,
        m.relative_humidity_2m_min,

        -- vent 
        m.wind_speed_10m,
        m.wind_speed_10m_max,

        -- nuages
        m.cloud_cover,
        m.cloud_cover_min

    FROM {{ ref('int_pour_mart_mois') }} AS m

    INNER JOIN {{ ref('dim_localisation') }} AS l
        ON m.ville = l.ville AND m.island = l.island

    INNER JOIN {{ ref('dim_temps_mois') }} AS d
        ON m.mois = d.date_mois AND m.annee = d.annee
    
    INNER JOIN {{ ref('dim_weather') }} AS w
        ON m.weather_code_simple = w.weather_code
),

calculs AS (

    SELECT 
        *,

        -- besoin irrigation
        CASE
            WHEN (et0_fao_evapotranspiration - (precipitation * 0.8)) > 0
            THEN ROUND(et0_fao_evapotranspiration - (precipitation * 0.8), 2)
            ELSE 0
        END AS besoin_irrigation,

        -- bilan hydrique
        ROUND(precipitation - evapotranspiration, 2) AS bilan_hydrique

    FROM base
)

select * from calculs