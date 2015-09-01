#' @title 
#' Control all the DIK data sets for errors
#' 
#' @param db_path
#'
#' @details 
#' Run tests on the datasets in the DIK db to check for errors. 
#' 
#' 
check_dik_data <-function(db_path){
  files_in_db_path <- dir(db_path)
  csv_files <- files_in_db_path[grepl(pattern = "csv", files_in_db_path)] 

  # To check in all files
  for(i in seq_along(csv_files)){ 
    temp_df <- read.csv(paste0(db_path,csv_files[i]), fileEncoding="utf8")
    if(!all(tolower(temp_df$month) %in% months_constant())){
      stop(paste0("Error in month names in ", csv_files[i]))
    }
  }
}