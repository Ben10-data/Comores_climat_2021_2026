WITH base AS (

    SELECT 
        {{ dbt_utils.generate_surrogate_key(['d.date_jour_id','l.localisation_id']) }} AS fait_agriculture_id,

        d.date_jour_id AS date_id,
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

    FROM {{ ref('int_pour_mart_jour') }} AS m

    INNER JOIN {{ ref('dim_localisation') }} AS l
        ON m.ville = l.ville AND m.island = l.island

    INNER JOIN {{ ref('dim_temps_jour') }} AS d
        ON m.date_jour = d.date_jour
    
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
),

final AS (

    SELECT 
        *,

        -- categorie irrigation
        CASE 
            WHEN besoin_irrigation > 4 THEN 'Irrigation nécessaire'
            ELSE 'Pas besoin irrigation'
        END AS categorie_irrigation,

        -- categorie bilan hydrique
        CASE 
            WHEN bilan_hydrique < -3 THEN 'Déficit hydrique sévère'
            WHEN bilan_hydrique BETWEEN -3 AND 0 THEN 'Déficit hydrique modéré'
            WHEN bilan_hydrique BETWEEN 0 AND 3 THEN 'Bilan hydrique équilibré'
            ELSE 'Excès hydrique'
        END AS categorie_bilan_hydrique,

    
        CASE
            WHEN vapour_pressure_deficit_max > 1.5 THEN 1 ELSE 0
        END AS flag_stress_hydrique,

        CASE
            WHEN precipitation > 50 OR rain_max > 30 THEN 1 ELSE 0
        END AS flag_pluie_excessive,

        CASE
            WHEN precipitation < 2
             AND vapour_pressure_deficit > 1.2
             AND relative_humidity_2m < 70
            THEN 1 ELSE 0
        END AS flag_secheresse,

        SUM(
            CASE
                WHEN precipitation < 2
                 AND vapour_pressure_deficit > 1.2
                 AND relative_humidity_2m < 70
                THEN 1 ELSE 0
            END
        ) OVER (
            PARTITION BY localisation_id
            ORDER BY date_id
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS jours_secheresse_7j

    FROM calculs
)

SELECT * FROM final