
from geopy.geocoders import Nominatim
from src.telechargement import Telechargement

# Initialisation du géolocator
geolocator = Nominatim(user_agent="geo_exemple")

# Villes / Localités principales de Ndzuwani (Anjouan)

# Mutsamudu - capitale, altitude ~60 m
# location1 = geolocator.reverse("-12.2131,44.3950")
# print(f'Mutsamudu: {location1.address}')

# # Domoni - ville côtière sud-est, altitude ~20 m
# location2 = geolocator.reverse("-12.2881,44.4344")
# print(f'Domoni: {location2.address}')

# # Sima - ville côtière est, altitude ~10 m
# location3 = geolocator.reverse("-12.2200,44.4570")
# print(f'Sima: {location3.address}')

# # Ouani - partie nord-est, altitude ~50 m
# location4 = geolocator.reverse("-12.1325,44.4333")
# print(f'Ouani: {location4.address}')

# # Hahaya - localité centrale, altitude ~70 m
# location5 = geolocator.reverse("-12.2500,44.3900")
# print(f'Hahaya: {location5.address}')

# # Bimbini - village sud-ouest, altitude ~15 m
# location6 = geolocator.reverse("-12.3000,44.3600")
# print(f'Bimbini: {location6.address}')

# # Mont Ntringui - volcan intérieur, altitude ~1 595 m
# location7 = geolocator.reverse("-12.2667,44.3833")
# print(f'Mont Ntringui: {location7.address}')



if __name__ == "__main__":
   
    ville = "Mont de Ntringui"
    a1 = Telechargement(-12.2667, 44.3833, "Anjouan",f"/home/ben/Bureau/climat_Comores/data/{ville}.csv")
    a1.get_telechargement()
