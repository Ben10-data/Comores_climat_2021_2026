with dim_localisation as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['ville', 'island']) }} as localisation_id,
        ville, island, latitude, longitude, grille_meteo
    from {{ ref('int_pour_mart_heure') }}
)

select * from dim_localisation