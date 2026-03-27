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

traitement_null as (

    select
        *,
        case 
            when weather_code is not null then weather_code

            when precipitation > 0 then 
                case 
                    when precipitation < 2 then 61
                    when precipitation < 10 then 63
                    else 65
                end

            when cloud_cover > 80 then 3
            when cloud_cover > 20 then 2
            else 0
        end as weather_code_clean

    from joined

)

select * from traitement_null where rain is not null 
