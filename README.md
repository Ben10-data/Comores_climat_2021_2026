# 🌦️ Comores Climat 2021–2026

> Plateforme d'acquisition, de transformation et d'analyse des données météorologiques des Comores à partir de l'API Open-Meteo.

Ce projet met en place une **pipeline Data moderne** permettant de :

- Collecter automatiquement les données météorologiques historiques des Comores ;
- Stocker les données dans PostgreSQL ;
- Transformer les données avec **dbt** ;
- Construire un Data Warehouse orienté analyse ;
- Produire des Data Marts métiers (agriculture, tourisme, santé, aviation, climat) ;
- Visualiser les résultats avec **Streamlit**.

---

# 📌 Architecture

```
                  Open-Meteo API
                         │
                         ▼
               Python (Extraction)
                         │
                         ▼
                 CSV / Prétraitement
                         │
                         ▼
                  PostgreSQL (Raw)
                         │
                         ▼
                     dbt Models
          ┌──────────────┼──────────────┐
          │              │              │
     Staging       Intermediate      Dimensions
          │              │              │
          └──────────────┼──────────────┘
                         ▼
                    Data Marts
      Agriculture • Santé • Aviation
      Tourisme • Climat (heure/jour/mois)
                         │
                         ▼
                    Streamlit Dashboard
```

---

# 📂 Structure du projet

```
Comores_climat_2021_2026/

│
├── base_de_donnee/
│   └── docker-compose.yaml
│
├── dbt/
│   ├── Dockerfile
│   ├── docker-compose.yaml
│   └── dbt_project/
│
├── src/
│   ├── telechargement.py
│   ├── pretraitement.py
│   └── meta_donnee_schema.sql
│
├── streamlit/
│   ├── Dockerfile
│   ├── docker-compose.streamlit.yaml
│   └── streamlit_app/
│
├── docker-compose.yaml
│
└── README.md
```

---

# 🚀 Fonctionnalités

Le projet permet de :

- téléchargement automatique des données Open-Meteo
- géolocalisation des stations avec Geopy
- stockage PostgreSQL
- transformations avec dbt
- création d'un Data Warehouse
- création de Data Marts
- visualisation Streamlit
- architecture entièrement conteneurisée avec Docker

---

# 🌍 Données collectées

Les données sont récupérées toutes les heures entre **20 mars 2021** et **03 février 2026**.

Variables récupérées :

- température à 2m
- température à 80m
- température à 120m
- température à 180m
- humidité relative
- point de rosée
- pluie
- précipitations
- probabilité de pluie
- vitesse du vent
- direction du vent
- rafales
- pression atmosphérique
- pression au sol
- couverture nuageuse
- visibilité
- température ressentie
- évapotranspiration
- ET0 FAO
- déficit de pression de vapeur
- code météo
- averses

Chaque observation contient également :

- date
- île
- ville
- coordonnées
- grille météorologique

---

# 🛰 Source des données

Les données proviennent de :

- Open-Meteo Historical Forecast API

Le téléchargement est réalisé via :

- openmeteo_requests
- requests_cache
- retry_requests
- Geopy

---

# ⚙️ Pipeline de téléchargement

La classe `Telechargement` est responsable de :

- connexion à Open-Meteo
- gestion automatique du cache
- reprise automatique en cas d'erreur
- récupération de toutes les variables météo
- géolocalisation
- génération d'un DataFrame Pandas
- export CSV

---

# 🗄 Base de données

Les données brutes sont stockées dans PostgreSQL.

Le conteneur est défini dans :

```
base_de_donnee/docker-compose.yaml
```

Configuration :

- PostgreSQL 16
- variables d'environnement
- persistance des données
- réseau Docker partagé

---

# 🏗 Transformation avec dbt

Les transformations sont réalisées avec **dbt**.

Organisation :

```
models/

staging/

intermediate/

dimensions_data/

marts/
```

---

## Dimensions

Le projet construit plusieurs dimensions :

- dim_localisation
- dim_temps
- dim_temps_jour
- dim_temps_mois
- dim_weather

---

## Tables de faits

### Climat

- fait_climat

---

### Agriculture

- fait_agriculture
- fait_agriculture_mois

---

### Santé

- fait_sante_confort

---

### Aviation

- fait_aviation

---

### Tourisme

- fait_tourisme

---

# 📊 Data Marts

Les analyses sont produites selon plusieurs granularités.

## Heure

```
marts/
    climat_heure/
```

Permet l'analyse horaire.

---

## Jour

```
marts/
    climat_jour/
```

Permet l'analyse journalière.

---

## Mois

```
marts/
    climat_mois/
```

Permet les analyses mensuelles.

---

# 📈 Tableau de bord Streamlit

Les résultats sont exposés via Streamlit.

Le conteneur est situé dans :

```
streamlit/
```

Il permet notamment :

- suivi de la température
- évolution des précipitations
- analyse des vents
- confort climatique
- agriculture
- aviation
- tourisme

---

# 🐳 Docker

Le projet est entièrement conteneurisé.

Le fichier principal :

```
docker-compose.yaml
```

inclut automatiquement :

- PostgreSQL
- dbt
- Streamlit

```
include:
  - ./base_de_donnee/docker-compose.yaml
  - ./dbt/docker-compose.yaml
  - ./streamlit/docker-compose.streamlit.yaml
```

---

# ▶️ Installation

Cloner le projet

```bash
git clone https://github.com/Ben10-data/Comores_climat_2021_2026.git
```

Entrer dans le projet

```bash
cd Comores_climat_2021_2026
```

Créer le réseau Docker

```bash
docker network create comores_meteo
```

Lancer les services

```bash
docker compose up -d
```

---

# ▶️ Exécution

Télécharger les données

```bash
python src/telechargement.py
```

Lancer les transformations dbt

```bash
dbt run
```

Exécuter les tests

```bash
dbt test
```

Lancer Streamlit

```
http://localhost:8501
```

---

# 📚 Technologies

- Python
- Pandas
- PostgreSQL
- Docker
- Docker Compose
- dbt
- Streamlit
- Open-Meteo API
- Geopy
- Requests Cache

---

# 🎯 Cas d'usage

Les Data Marts permettent de répondre à plusieurs problématiques :

### 🌾 Agriculture

- périodes favorables aux cultures
- suivi des précipitations
- évapotranspiration
- humidité

---

### ✈ Aviation

- visibilité
- rafales
- vitesse du vent
- couverture nuageuse

---

### 🏥 Santé

- confort thermique
- humidité
- température ressentie
- risques liés aux fortes chaleurs

---

### 🏝 Tourisme

- saisons favorables
- météo des îles
- journées ensoleillées
- périodes de pluie

---

### Analyse climatique

- évolution climatique entre 2021 et 2026
- comparaison entre les îles
- indicateurs météorologiques
- statistiques mensuelles et journalières

---

#  Auteur

**Ben Omar**

Data Engineer | Data Scientist

GitHub : https://github.com/Ben10-data
```
````
