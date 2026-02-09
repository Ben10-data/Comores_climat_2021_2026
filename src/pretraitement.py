import os
import pandas as pd

class Pretraitement:

    def __init__(self, lien_dossier):
        self.dossier = lien_dossier
    
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

        return data
    
    # creation du fichier csv qui contient tout les données 
    def creation_csv(self, lien):
        self.lien = lien 
        return self.supp_lignes_vides().to_csv(self.lien)