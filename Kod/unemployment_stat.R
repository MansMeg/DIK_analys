
# Install DIK package
devtools::install_github(repo = "MansMeg/DIK_analys", subdir = "Package")
# Load DIK package
library(DIK)


# Ange sökväg till AEA-filen
file_path <- "/Users/manma97/Dropbox/Projekt/DIK_analys/AEA/arbetsloshetsstatistik_36_20140108.csv"

# Läs in datan i R
AEA_data <- DIK::read_AEA_file(file_path)

# Gör beräkningar/producera statistik
dik_stat <- DIK::aggr_unempl_data(AEA_data)

# Lägg till i statistikdatabasen
DIK::write_dik_stat_csv(dik_stat, db_path = "Data/")
