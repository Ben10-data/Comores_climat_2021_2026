with aviation as (
    select 
        {{ dbt_utils.generate_surrogate_key([ 'd.temps_id', 'l.localisation_id']) }} AS fait_aviation_id,
        d.temps_id       AS date_id,
        l.localisation_id AS localisation_id,
        w.weather_id      AS weather_id,

        m.visibility,
        m.wind_speed_10m,
        m.wind_gusts_10m,
        m.wind_direction_10m,
        m.cloud_cover_low,
        m.cloud_cover_mid,
        m.cloud_cover_high,
        m.pressure_msl,
        m.showers,          

        case 
            when m.cloud_cover_low >= 75 then 100   
            when m.cloud_cover_low >= 50 then 250  
            when m.cloud_cover_low >= 25 then 600   
            else 1500                              
        end as plafond_estime_m,  

        case 
            when m.wind_gusts_10m > 55 or m.wind_speed_10m > 35 then 2
            when m.wind_gusts_10m > 37 or m.wind_speed_10m > 25 then 1
            else 0
        end as score_rafale_vent,

        case 
            when m.showers > 5 then 2 
            when m.showers > 0 then 1 
            else 0
        end as score_precipitation

    from {{ ref('int_pour_mart_heure') }} as m
    inner join {{ ref('dim_localisation') }} as l
        on m.ville   = l.ville 
       and m.island  = l.island
    inner join {{ ref('dim_temps') }} as d
        on m.date_heure = d.date_heure  
    inner join {{ ref('dim_weather') }} as w
        on m.weather_code_clean = w.weather_code    
),

score as (
    select 
        *,
        case
            when visibility < 800  or plafond_estime_m < 150  then 3
            when visibility < 1600 or plafond_estime_m < 300  then 2
            when visibility < 5000 or plafond_estime_m < 1000 then 1
            else 0
        end as score_base

    from aviation
),

final as (
    select *,
        least(score_base + score_rafale_vent + score_precipitation, 3) as score_total
    from score
)

select 
      *,
    case
        when score_total = 3 then 'Très défavorable'
        when score_total = 2 then 'Défavorable'
        when score_total = 1 then 'Moyennement favorable'
        else                      'Favorable'
    end as condition_aviation

from final