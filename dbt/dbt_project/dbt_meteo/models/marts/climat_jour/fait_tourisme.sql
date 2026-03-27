WITH score_tourisme AS (

    SELECT
        {{ dbt_utils.generate_surrogate_key([ 'd.date_jour_id', 'l.localisation_id ']) }} AS fait_tourisme_id,
        d.date_jour_id AS date_id,
        l.localisation_id  AS localisation_id,
        w.weather_id  AS weather_id,
        
        m.temperature_2m,
        m.temperature_2m_max,
        m.apparent_temperature,
        m.precipitation,
        m.cloud_cover,
        m.visibility,
        m.wind_speed_10m,
        m.relative_humidity_2m,
        m.wind_gusts_10m,


        CASE
            WHEN m.apparent_temperature BETWEEN 22.1 AND 30 THEN 3
            WHEN m.apparent_temperature BETWEEN 18.1 AND 22 THEN 2
            WHEN m.apparent_temperature BETWEEN 30 AND 34 THEN 2
            WHEN m.apparent_temperature BETWEEN 14 AND 18 THEN 1
            WHEN m.apparent_temperature BETWEEN 34.1 AND 38 THEN 1
            ELSE 0
        END AS score_temperature,

   
        CASE
            WHEN m.cloud_cover < 20 THEN 3
            WHEN m.cloud_cover < 40 THEN 2
            WHEN m.cloud_cover < 70 THEN 1
            ELSE 0
        END AS score_cloud_cover,


        CASE
            WHEN m.precipitation = 0 THEN 3
            WHEN m.precipitation <= 0.5 THEN 2
            WHEN m.precipitation <= 3 THEN 1
            ELSE 0
        END AS score_precipitation,

  
        CASE
           when m.wind_speed_10m <= 10 and m.wind_gusts_10m <= 20 then 3
           when m.wind_speed_10m <= 20 and m.wind_gusts_10m <= 35 then 2
            WHEN m.wind_speed_10m <= 35 THEN 1
            ELSE 0
        END AS score_wind,
        
        case
            when m.relative_humidity_2m between 50 and 75 then 3
            when m.relative_humidity_2m between 75 and 85 then 2
            when m.relative_humidity_2m between 85 and 92 then 1
           else 0
        end as score_humidity,

        CASE
            WHEN m.visibility > 10000 THEN 3
            WHEN m.visibility > 6000 THEN 2
            WHEN m.visibility > 3000 THEN 1
            ELSE 0
        END AS score_visibility

    FROM {{ ref('int_pour_mart_jour') }} AS m

    INNER JOIN {{ ref('dim_localisation') }} AS l
        ON m.ville  = l.ville AND m.island = l.island

    INNER JOIN {{ ref('dim_temps_jour') }} AS d
        ON m.date_jour = d.date_jour
    
    INNER JOIN {{ ref('dim_weather') }} AS w
        ON m.weather_code_simple = w.weather_code 

),

score_final AS (

    SELECT
        *,

        ROUND(
            score_precipitation * 0.30
            + score_temperature * 0.20
            + score_humidity  * 0.20
            + score_wind  * 0.15
            + score_cloud_cover * 0.10
            + score_visibility  * 0.05
        , 2) AS score_tourisme_brut,

        ROUND(
            (
                  score_precipitation * 0.35
                + score_temperature   * 0.25
                + score_wind          * 0.20
                + score_cloud_cover   * 0.10
                + score_visibility    * 0.10
            ) * (10.0 / 3)
        , 1) AS score_tourisme_final

    FROM score_tourisme

)

SELECT * FROM score_final