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
-- date
('meteo_par_jour','date','TEXT',
 'ISO 8601 date (YYYY-MM-DD or datetime)',
 NULL,NULL,NULL,NULL,
 FALSE,'Open-Meteo'),

-- temperature
('meteo_par_jour','temperature_2m','FLOAT','°C',
 3.9,35.759,-1,50,
 FALSE,'Open-Meteo'),

-- humidity
('meteo_par_jour','relative_humidity_2m','FLOAT','%',
 32,100,0,200,
 FALSE,'Open-Meteo'),

-- dew point
('meteo_par_jour','dew_point_2m','FLOAT','°C',
 -2.183547,28.286875,-5,50,
 FALSE,'Open-Meteo'),

-- rain
('meteo_par_jour','rain','FLOAT','mm',
 0.0,43.8,0,300,
 TRUE,'Open-Meteo'),

-- precipitation probability
('meteo_par_jour','precipitation_probability','FLOAT','%',
 0,100,NULL,NULL,
 TRUE,'Open-Meteo'),

-- precipitation
('meteo_par_jour','precipitation','FLOAT','mm',
 0.0,45.0,0,300,
 TRUE,'Open-Meteo'),

-- wind speed 10m
('meteo_par_jour','wind_speed_10m','FLOAT','km/h',
 0,53.096035,0,100,
 FALSE,'Open-Meteo'),

-- wind direction
('meteo_par_jour','wind_direction_10m','FLOAT','degrees (0–360)',
 0,54,0,360,
 FALSE,'Open-Meteo'),

-- wind speed 80m
('meteo_par_jour','wind_speed_80m','FLOAT','km/h',
 0.584628,62.938255,NULL,NULL,
 TRUE,'Open-Meteo'),

-- wind speed 120m
('meteo_par_jour','wind_speed_120m','FLOAT','km/h',
 0,65.337296,NULL,NULL,
 TRUE,'Open-Meteo'),

-- cloud cover high
('meteo_par_jour','cloud_cover_high','FLOAT','%',
 -1.0,101.0,NULL,NULL,
 TRUE,'Open-Meteo'),

-- pressure msl
('meteo_par_jour','pressure_msl','FLOAT','hPa',
 1003.6,1024,950,1050,
 FALSE,'Open-Meteo'),

-- surface pressure
('meteo_par_jour','surface_pressure','FLOAT','hPa',
 770.68884,1023.4,950,1050,
 FALSE,'Open-Meteo'),

-- visibility
('meteo_par_jour','visibility','FLOAT','meters',
 100.0,24140.0,0,50000,
 TRUE,'Open-Meteo'),

-- weather code
('meteo_par_jour','weather_code','INTEGER','WMO weather code',
 0,96,0,99,
 TRUE,'Open-Meteo'),

-- apparent temperature
('meteo_par_jour','apparent_temperature','FLOAT','°C',
 1.360477,42.50478,-5,55,
 FALSE,'Open-Meteo'),

-- evapotranspiration
('meteo_par_jour','evapotranspiration','FLOAT','mm/day',
 0,0.58,0,10,
 TRUE,'Open-Meteo'),

-- et0 fao
('meteo_par_jour','et0_fao_evapotranspiration','FLOAT','mm/day',
 0.0,0.862587,0,10,
 TRUE,'Open-Meteo'),

-- vpd
('meteo_par_jour','vapour_pressure_deficit','FLOAT','hPa',
 0.0,3.984451,0,50,
 TRUE,'Open-Meteo'),

-- showers
('meteo_par_jour','showers','FLOAT','mm',
 0.0,21.30,0,200,
 TRUE,'Open-Meteo'),

-- dimensions
('meteo_par_jour','island','TEXT',NULL,
 NULL,NULL,NULL,NULL,
 FALSE,'Internal'),

('meteo_par_jour','ville','TEXT',NULL,
 NULL,NULL,NULL,NULL,
 FALSE,'Internal'),

('meteo_par_jour','grille_meteo','TEXT',NULL,
 NULL,NULL,NULL,NULL,
 FALSE,'Internal');
