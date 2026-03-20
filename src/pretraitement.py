import os
import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path
from dotenv import load_dotenv
load_dotenv()


# env_path = Path('../base_de_donnee/.env')
# load_dotenv(dotenv_path=env_path)

BASE_DIR = Path(__file__).resolve().parent
env_path = BASE_DIR.parent / "base_de_donnee" / ".env"

load_dotenv(dotenv_path=env_path)

class Pretraitement:

    def __init__(self, lien_dossier, lien_fichier_concatene):
        self.dossier = lien_dossier
        self.lien_fichier_concatene = lien_fichier_concatene
        self._postgres_connection = None
    
    # suppression des lignes vides et concatenation des dataframes 
    def supp_lignes_vides(self):
        dataframes = []

        for fichier in os.listdir(self.dossier):
            if fichier.endswith(".csv"):
                chemin = os.path.join(self.dossier, fichier)
                df = pd.read_csv(chemin)
                dataframes.append(df)

        data = pd.concat(dataframes, ignore_index=True)
        data = data[data["temperature_2m"].notna()]
        data = data.loc[:, ~data.columns.str.contains('^Unnamed')]

        return data
    
    # creation du fichier csv qui contient tout les données 
    def creation_csv(self):
        self.supp_lignes_vides().to_csv(self.lien_fichier_concatene, index=False)
        return self.lien_fichier_concatene
    
    #-------------- connection Postgres -----------------------#
    def get_postCon(self):
        if self._postgres_connection is None : 
            user = os.getenv('Post_user')
            host = "localhost"
            password=os.getenv('Post_pwd')
            port = 5492
            db= os.getenv('Post_DB')
            self._postgres_connection = create_engine(f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}")
    
        return self._postgres_connection
    
    def insert_data(self, table_name):
        data = self.supp_lignes_vides()
        engine = self.get_postCon()
        data.to_sql(table_name, con=engine, if_exists='append', index=False)
        print(f" Les données sont enregistrées dans la table{table_name} avec succees.")


        
    
    