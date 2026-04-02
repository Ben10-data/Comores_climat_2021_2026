with dim_temps as (
    select distinct 
        {{ dbt_utils.generate_surrogate_key(['date_heure']) }} as temps_id,
        date_heure, 
        hour(date_heure) as heure,
        day(date_heure) as jour, 
        month(date_heure) as mois,
        year(date_heure) as annee
    from {{ ref('int_pour_mart_heure') }}

),
dim_saison as (

    select 
         d.*,
        case 
            when mois in (1,2,3,11,12) then 'Saison des pluies'
            when mois in (4,5) then 'Inter-saison humide'
            when mois in (6,7,8,9,10) then 'Saison sèche'
            when mois = 11 then 'Inter-saison sèche'
            else 'Inconnu'
        end as saison,

        case 
            when extract(dow from date_heure) in (0,6) then TRUE
            else FALSE
        end as is_weekend

    from dim_temps as d 
)

select * from dim_saison