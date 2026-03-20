
from geopy.geocoders import Nominatim
from src.telechargement import Telechargement

# Initialisation du géolocator
geolocator = Nominatim(user_agent="geo_exemple")

# ville a rajouter 
# Ngazidja
Mitsa = "-11.388,43.283"
lac_sale = "-11.368,43.305"
mbadjini_ouest = "-11.847,43.319"
mbadjini_est = "-11.837,43.359"

#anjouan 
mutsamudu = "-12.159,44.412"
Page = "-12.178,44.386"
Daji = "-12.312,44.493"
Chiroroni = "-12.374,44.502"
Domoni = "-12.259,44.518"
BImbini = "-12.194,44.236"

# Mwali
Domoni = "-12.257,43.639"
MIringoni = "-12.302,43.627"
Itsamia = "-12.370,43.858"
Hamavouna = "-12.378,43.834"



if __name__ == "__main__":
   
    ville = "Mbandj_1"
    a1 = Telechargement(-11.847,43.319, "Ngazidja",f"/home/ben/Bureau/climat_Comores/data1/{ville}.csv")
    a1.get_telechargement()
