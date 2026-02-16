from src.pretraitement import Pretraitement


if __name__ == "__main__":

    a = Pretraitement("./data", "./donnee_concatene/donnee1.csv")
    #a.creation_csv()
    a.get_postCon()
    a.insert_data("meteo_par_heure")
