with sante_confort as (
     select 
       {{ dbt_utils.generate_surrogate_key([ 'd.date_jour_id', 'l.localisation_id']) }} AS fait_sante_id,
       d.date_jour_id AS date_id,
       l.localisation_id  AS localisation_id,
       w.weather_id  AS weather_id,

        --temperature
        m.temperature_2m,
        m.temperature_2m_min,
        m.temperature_2m_max,
        
        --ressenti température
        m.apparent_temperature,
        m.apparent_temperature_max,
        m.apparent_temperature_min,
        
        -- humidity
        m.relative_humidity_2m,
        m.relative_humidity_2m_min,
        m.relative_humidity_2m_max,
        m.dew_point_2m,
        m.dew_point_2m_min,
        m.dew_point_2m_max,

        -- vent
        m.wind_speed_10m,
        m.wind_speed_10m_max,
        m.wind_gusts_10m_max,

        -- stress hydrique
        m.vapour_pressure_deficit,
        m.vapour_pressure_deficit_max,

        --nuage et visibilité
        m.cloud_cover,
        m.visibility,
        m.visibility_min,

        -- humidex 

        ROUND(
          (m.temperature_2m_max + 0.5555 * (6.11* (exp(5417.7530*((1/273.16)-(1/(273.15+m.dew_point_2m)))
          ))) -10
          ), 3) AS indice_humidex,

          -- chaleur 
        CASE
            WHEN m.TEMPERATURE_2M_MAX < 27 THEN m.TEMPERATURE_2M_MAX
            ELSE ROUND(-8.78 + 1.61*m.TEMPERATURE_2M_MAX + 2.34*m.RELATIVE_HUMIDITY_2M
                 - 0.15*m.TEMPERATURE_2M_MAX*m.RELATIVE_HUMIDITY_2M, 1)
        END AS INDICE_CHALEUR,

        case
            when indice_humidex >= 45 then 'Danger'
            when indice_humidex >= 40 then 'Très inconfortable'
            when indice_humidex >= 35.1 then 'Inconfort'
            else 'Confortable'
         end as categorie_humidex,

        -- Flags
        CASE WHEN m.APPARENT_TEMPERATURE_MAX > 37 AND m.TEMPERATURE_2M_MIN > 25
             THEN 1 ELSE 0 
        END AS FLAG_CANICULE,

        CASE WHEN m.APPARENT_TEMPERATURE_MIN < 20
             THEN 1 ELSE 0 
        END AS FLAG_FROID_RELATIF,

        CASE WHEN m.TEMPERATURE_2M_MAX > 32
              AND m.VAPOUR_PRESSURE_DEFICIT_MAX > 2.0
              AND m.WIND_SPEED_10M_MAX > 30
              AND m.PRECIPITATION < 1.0
             THEN 1 ELSE 0 
        END AS FLAG_RISQUE_INCENDIE

      
    FROM {{ ref('int_pour_mart_jour') }} AS m

    INNER JOIN {{ ref('dim_localisation') }} AS l
        ON m.ville  = l.ville AND m.island = l.island

    INNER JOIN {{ ref('dim_temps_jour') }} AS d
        ON m.date_jour = d.date_jour
    
    INNER JOIN {{ ref('dim_weather') }} AS w
        ON m.weather_code_simple = w.weather_code 
        
)

select * from sante_confort


