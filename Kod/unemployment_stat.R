# Problem with windows
lib_path <- "C:/Users/stiham/Rpackages/3.2"
.libPaths(c(lib_path, .libPaths()))

# Install DIK package
devtools::install_github(repo = "MansMeg/DIK_analys", subdir = "Package")

# Load DIK package
library(DIK)

# Ange sökväg till AEA-filen
file_path <- file.choose()
file_path <- "test_file/arbetsloshetsstatistik_36_201804_20181016.csv"

# Läs in datan i R
AEA_data <- read_AEA_file(file_path)
AEA_data <- read_AEA_file(file_path, stat_var = c("stat1"="intrgrp", "stat2"="sektor", "stat3"="anst", "stat4" = "utbniva", "stat5" = "utbgrp"))

# Gör beräkningar/producera statistik
dik_stat <- aggr_unempl_data(AEA_data = AEA_data)

# Lägg till i statistikdatabasen
write_dik_stat_csv(dik_stat, db_path = "Data/")


