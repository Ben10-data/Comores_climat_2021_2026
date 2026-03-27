with mart_mois as (

 select * from {{ ref('int_pour_mart_mois') }}

)

select * from mart_mois