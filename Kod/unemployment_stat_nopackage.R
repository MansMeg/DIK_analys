
# Läs in funktioner från "Package/R/" 
file_paths <- list.files("Package/R/", full.names = TRUE)
for(file_path in file_paths){
  source(file = file_path)
}

# Ange sökväg till AEA-filen
file_path <- "G:\\DIK\\DIK2015\\PM\\Stina 2015\\Arbetslöshetsstatistik\\FIler från AEA\\arbetsloshetsstatistik_36_juni.csv"
file_path <- file.choose()

# Läs in datan i R
AEA_data <- read_AEA_file(file_path)

# Gör beräkningar/producera statistik
dik_stat <- aggr_unempl_data(AEA_data)

# Lägg till i statistikdatabasen
write_dik_stat_csv(dik_stat, db_path = "Data/")
