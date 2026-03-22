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

)