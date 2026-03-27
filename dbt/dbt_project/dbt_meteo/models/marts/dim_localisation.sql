with dim_localisation as (
    select distinct
     ---  On garde ville parce que le module de ggeolocalisation, chaque ville est ecris avec sa region
        {{ dbt_utils.generate_surrogate_key(['ville', 'island']) }} as localisation_id,
        ville, island, latitude, longitude, grille_meteo
    from {{ ref('int_pour_mart_heure') }}
)

select * from dim_localisation