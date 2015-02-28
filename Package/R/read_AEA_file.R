#' @title
#' Read in DIK unemployment files from AEA
#' 
#' @param file_path
#'   Path to an AEA file
#' @param stat_var
#'   'stat' variables order in AEA file
#' 
#' @description
#' All files are read in to R and put in one data.frame, checks that the file is correct
#' is conducted.
#' 
#' @details
#' 
#'   anst : ex. Anställd, Arbetslös, Egen Företagare, Ej yrkesverksam, Föräldraledig, Pensionerad (anstallning)
#'   utbniva : ex. -2 år Univ/Högskola, -5 år- Univ/Högskola, Doktorsutbildning/examen, Magister, Studerande (utbniva)
#'   utbgrp : Utbildningsgrupper
#'   intrgrp : Intressegrupper
#'   sektor : ex. Statlig, privat, kommunal (sektor)
#'   
#' @return
#' \code{data.frame} of class AEA_data.
#' 
#' @export
#' 
read_AEA_file <- function(file_path, stat_var=c("anst", "utbniva", "utbgrp", "intrgrp", "sektor")){
  if(!file.exists(file_path)) stop("File does not exist.")
  if(!all(stat_var %in% c("anst", "utbniva", "utbgrp", "intrgrp", "sektor"))) stop("stat_var do not contain the correct names.")

  AEAdf <- read.csv(file = file_path, fileEncoding="cp1252", stringsAsFactors=TRUE)
  
  # File checks
  var_names <- 
    c("manad", "forbund", "alder", "kon", "lan", "ers", "utbprogram", "infopost",
      "avisering", paste0("stat", 1:5))
  var_exist <- var_names %in% names(AEAdf)
  if(!all(var_exist)) warning(paste0("The following variables is missing: \n'", 
                                     paste(var_names[!var_exist], collapse = "', '"), "'"), call. = FALSE)
  # Change names
  names(AEAdf)[names(AEAdf) %in% paste0("stat", 1:5)] <- stat_var
  
  # Check that classes exist that is needed
  if(!all(c("Studerande") %in% levels(AEAdf$anst))) warning("'Studerande' is missing in variable 'stat1'.", call. = FALSE)
  if(any(stringr::str_detect(string = levels(AEAdf$utbniva), pattern = "Univ")) warning("'Univ' is missing in variable 'stat2'.", call. = FALSE)
  if(any(stringr::str_detect(string = levels(AEAdf$utbgrp), pattern = "Humaniora")) warning("'Humaniora' is missing in variable 'stat1'.", call. = FALSE)
  if(!all(c("Direkt","Förbund") %in% levels(AEAdf$avisering))) warning("'Direkt' and/or 'Förbund' is missing in variable 'avisering'.", call. = FALSE)
  if(!all(c("X") %in% levels(AEAdf$ers))) warning("'X' is missing in variable 'ers'.", call. = FALSE)
  if(!all(c("X") %in% levels(AEAdf$infopost))) warning("'X' is missing in variable 'infopost'.", call. = FALSE)
  
  
  # "Jobb och utvecklingsgaranti"
  
  # Corrections
  levels(AEAdf$lan)[levels(AEAdf$lan) == ""] <- "Okänd"
  
  # Setting addition class
  class(AEAdf) <- c("AEA_data", "data.frame")
  
  return(AEAdf)
}


#' @title
#' Check if x has class AEA_data
#' 
#' @param x object to check.
#' @param class_name check for this class
#' 
#' @description
#' Test if x is an object of class AEA_data, otherwise generates warning.
#' 
#' 
check_class <- function(x, class_name){
  if(!class_name %in% class(x)) {
    if(class_name == "AEA_data") {
      warning("Data not read with read_AEA_files()", call. = FALSE)
    } else {
      warning("Object not of class ", class_name, call. = FALSE)      
    }
  }
}