# Packages needed in code
needed_packages <- c("httr", "stringr")

# Identify which packages that is not already installed
not_installed_packages <- needed_packages[!needed_packages %in% installed.packages()[,1]]
# Install those packages
if(length(not_installed_packages) > 0) install.packages(not_installed_packages)
# Load needed packages
for( pkg in needed_packages){
  library(pkg, character.only = TRUE)
}

# Läs in funktioner från "Package/R/" 
file_paths <- list.files("Package/R/", full.names = TRUE)



for(file_path in file_paths){
  source(file = file_path)
}



# Ange sökväg till AEA-filen
file.choose()
file_path <- "G:\\DIK\\DIK2016\\PM\\Stina 2016\\Arbetslöshetsstatistik\\Från AEA\\arbetsloshetsstatistik_36_20170118_dec.csv"


# Läs in datan i R
AEA_data <- read_AEA_file(file_path)

# Gör beräkningar/producera statistik
dik_stat <- aggr_unempl_data(AEA_data)

# Lägg till i statistikdatabasen
write_dik_stat_csv(dik_stat, db_path = "Data/")
