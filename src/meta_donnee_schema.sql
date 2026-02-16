
-- shema de mes metadonnées 

    -- "showers": {
    --     "type": float,
    --     "min_obs": 0.0,
    --     "max_obs": 21.30,
    --     "hard_min": 0,
    --     "hard_max": 200,
    --     "nullable": True,
    --     "unit": "mm"
    -- },



-- Creation de la table du metadonne 

CREATE TABLE metadata_columns (
    nom_du_table TEXT,
    column_name TEXT,
    data_type TEXT,
    unit TEXT,
    min_obs FLOAT,
    max_obs FLOAT,
    hard_min FLOAT,
    hard_max FLOAT,
    nullable BOOLEAN,
    source TEXT,
    created_at TIMESTAMP DEFAULT now()
);

-- INsertion des differentes colonnes 

INSERT INTO metadata_columns
(nom_du_table, column_name, data_type, unit,
 min_obs, max_obs, hard_min, hard_max,
 nullable, source)
VALUES


('meteo_par_heure','date','TEXT',
 'ISO 8601 date (YYYY-MM-DD or datetime)',
 NULL,NULL,NULL,NULL,
 FALSE,'Open-Meteo'),


('meteo_par_heure','temperature_2m','FLOAT','°C',
 3.9,35.759,-1,50,
 FALSE,'Open-Meteo'),


('meteo_par_heure','relative_humidity_2m','FLOAT','%',
 32,100,0,200,
 FALSE,'Open-Meteo'),


('meteo_par_heure','dew_point_2m','FLOAT','°C',
 -2.183547,28.286875,-5,50,
 FALSE,'Open-Meteo'),


('meteo_par_heure','rain','FLOAT','mm',
 0.0,43.8,0,300,
 TRUE,'Open-Meteo'),


('meteo_par_heure','precipitation_probability','FLOAT','%',
 0,100,NULL,NULL,
 TRUE,'Open-Meteo'),

('meteo_par_heure','precipitation','FLOAT','mm',
 0.0,45.0,0,300,
 TRUE,'Open-Meteo'),


('meteo_par_heure','wind_speed_10m','FLOAT','km/h',
 0,53.096035,0,100,
 FALSE,'Open-Meteo'),


('meteo_par_heure','wind_direction_10m','FLOAT','degrees (0–360)',
 0,54,0,360,
 FALSE,'Open-Meteo'),


('meteo_par_heure','wind_speed_80m','FLOAT','km/h',
 0.584628,62.938255,NULL,NULL,
 TRUE,'Open-Meteo'),

('meteo_par_heure','wind_speed_120m','FLOAT','km/h',
 0,65.337296,NULL,NULL,
 TRUE,'Open-Meteo'),


('meteo_par_heure','cloud_cover_high','FLOAT','%',
 -1.0,101.0,NULL,NULL,
 TRUE,'Open-Meteo'),

('meteo_par_heure','pressure_msl','FLOAT','hPa',
 1003.6,1024,950,1050,
 FALSE,'Open-Meteo'),

('meteo_par_heure','surface_pressure','FLOAT','hPa',
 770.68884,1023.4,950,1050,
 FALSE,'Open-Meteo'),

('meteo_par_heure','visibility','FLOAT','meters',
 100.0,24140.0,0,50000,
 TRUE,'Open-Meteo'),


('meteo_par_heure','weather_code','INTEGER','WMO weather code',
 0,96,0,99,
 TRUE,'Open-Meteo'),


('meteo_par_heure','apparent_temperature','FLOAT','°C',
 1.360477,42.50478,-5,55,
 FALSE,'Open-Meteo'),


('meteo_par_heure','evapotranspiration','FLOAT','mm/day',
 0,0.58,0,10,
 TRUE,'Open-Meteo'),

('meteo_par_heure','et0_fao_evapotranspiration','FLOAT','mm/day',
 0.0,0.862587,0,10,
 TRUE,'Open-Meteo'),


('meteo_par_heure','vapour_pressure_deficit','FLOAT','hPa',
 0.0,3.984451,0,50,
 TRUE,'Open-Meteo'),

('meteo_par_heure','showers','FLOAT','mm',
 0.0,21.30,0,200,
 TRUE,'Open-Meteo'),

('meteo_par_heure','island','TEXT',NULL,
 NULL,NULL,NULL,NULL,
 FALSE,'Internal'),

('meteo_par_heure','ville','TEXT',NULL,
 NULL,NULL,NULL,NULL,
 FALSE,'Internal'),

('meteo_par_heure','grille_meteo','TEXT',NULL,
 NULL,NULL,NULL,NULL,
 FALSE,'Internal');


-- Creation de la table meteo_par_heure
CREATE TABLE meteo_par_heure (
    date TEXT,
    temperature_2m FLOAT,
    relative_humidity_2m FLOAT,
    dew_point_2m FLOAT,
    rain FLOAT,
    precipitation_probability FLOAT,
    precipitation FLOAT,
    wind_speed_10m FLOAT,
    wind_direction_10m FLOAT,
    wind_speed_80m FLOAT,
    wind_speed_120m FLOAT,
    cloud_cover_high FLOAT,
    pressure_msl FLOAT,
    surface_pressure FLOAT,
    visibility FLOAT,
    weather_code INTEGER,
    apparent_temperature FLOAT,
    evapotranspiration FLOAT,
    et0_fao_evapotranspiration FLOAT,
    vapour_pressure_deficit FLOAT,
    showers FLOAT,
    island TEXT,
    ville TEXT,
    grille_meteo TEXT
);
d
comores_DB=# ALTER TABLE meteo_par_heure 
ADD PRIMARY KEY (date, island, ville); 

