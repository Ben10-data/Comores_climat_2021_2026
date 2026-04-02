with dim_temps_mois as (
    select distinct 
        {{ dbt_utils.generate_surrogate_key(['date_heure']) }} as date_mois_id,
         month(date_heure) as date_mois, year(date_heure) as annee,
        saison,
        is_weekend 
    from {{ ref('dim_temps') }}
)

select * from dim_temps_mois