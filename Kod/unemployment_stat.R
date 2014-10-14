

# Ange sökvägen till AEA-filen
file_path <- "/Users/manma97/Desktop/Out/arbetsloshetsstatistik_36_20140108.csv"
# Ange var resultatet ska sparas ned
result_path <- "/Users/manma97/Desktop/"

# Läs in datan i R
AEA_data <- read_AEA_file(file_path)

# Gör beräkningar/producera statistik
dik_stat <- calc_dik_stat(AEA_data)

# Skriv ut resultatet till csv-filer
write_dik_stat(dik_stat = dik_stat, results_path = "Temp/")
