with dim_temps_jour as (
    select distinct 
         {{ dbt_utils.generate_surrogate_key(['date_heure']) }} as date_jour_id,
        (date_heure::date) as date_jour,
        saison,
        is_weekend 
    from {{ ref('dim_temps') }}
)

select * from dim_temps_jour