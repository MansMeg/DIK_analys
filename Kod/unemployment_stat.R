
# Install DIK package
devtools::install_github(repo = "MansMeg/DIK_analys", subdir = "Package")
library(DIK)

# Ange sökvägen till AEA-filen
file_path <- "/Users/manma97/Desktop/Out/arbetsloshetsstatistik_36_20140108.csv"
# Ange var resultatet ska sparas ned
result_path <- "/Users/manma97/Desktop/"

# Läs in datan i R
AEA_data <- DIK::read_AEA_file(file_path)

# Gör beräkningar/producera statistik
dik_stat <- DIK::aggr_unempl_data(AEA_data)

# Add to stats database
DIK::write_dik_stat_csv(dik_stat, db_path = "Data/")
