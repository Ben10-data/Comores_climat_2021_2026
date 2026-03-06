with source as (

    select *
    from {{ source('meteo_comores','METEO_PAR_HEURE') }}

)

select * from source