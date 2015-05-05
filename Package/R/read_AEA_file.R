#' @title
#' Read in DIK unemployment files from AEA
#' 
#' @param file_path
#'   Path to an AEA file
#' @param stat_var
#'   'stat' variables order in AEA file. Need to assign "anst", "utbniva", "utbgrp", "intrgrp", "sektor" in stat variable order. (see examples) 
#'   If NULL (default) the function tries to find it out automatically.
#' 
#' @description
#' All files are read in to R and put in one data.frame, checks that the file is correct
#' is conducted.
#' 
#' @details
#'   anst : ex. Anställd, Arbetslös, Egen Företagare, Ej yrkesverksam, Föräldraledig, Pensionerad (anstallning)
#'   utbniva : ex. -2 år Univ/Högskola, -5 år- Univ/Högskola, Doktorsutbildning/examen, Magister, Studerande (utbniva)
#'   utbgrp : Utbildningsgrupper
#'   intrgrp : Intressegrupper
#'   sektor : ex. Statlig, privat, kommunal (sektor)
#'   
#' @return
#' \code{data.frame} of class AEA_data.
#' 
#' @examples
#' \dontrun{
#'  read_AEA_file(file_path, stat_var=c("anst", "utbniva", "utbgrp", "intrgrp", "sektor"))
#' }
#' 
#' @export
#' 
read_AEA_file <- function(file_path, stat_var=NULL){
  if(!file.exists(file_path)) stop("File does not exist.")
  if(!is.null(stat_var) | !all(stat_var %in% c("anst", "utbniva", "utbgrp", "intrgrp", "sektor"))) stop("stat_var do not contain the correct names.")

  AEAdf <- read.csv(file = file_path, fileEncoding="cp1252", stringsAsFactors=TRUE)
  
  # File checks
  var_names <- 
    c("manad", "forbund", "alder", "kon", "lan", "ers", "utbprogram", "infopost",
      "avisering", paste0("stat", 1:5))
  var_exist <- var_names %in% names(AEAdf)
  if(!all(var_exist)) warning(paste0("The following variables is missing: \n'", 
                                     paste(var_names[!var_exist], collapse = "', '"), "'"), call. = FALSE)
  # Change names
  if(is.null(stat_var)){
    for (st in paste0("stat", 1:5)){
      colname_index <- which(colnames(AEAdf) == st) 
      colnames(AEAdf)[colname_index] <- find_stat_var_name(AEAdf[,st])
    }    
  } else {
    names(AEAdf)[names(AEAdf) %in% paste0("stat", 1:5)] <- stat_var
  }

  # Check that classes exist that is needed
  if(!all(c("Studerande") %in% levels(AEAdf$anst))) warning("'Studerande' is missing in variable 'stat1'.", call. = FALSE)
  if(!any(stringr::str_detect(string = levels(AEAdf$utbniva), pattern = "Univ"))) warning("'Univ' is missing in variable 'stat2'.", call. = FALSE)
  if(!any(stringr::str_detect(string = levels(AEAdf$utbgrp), pattern = "Humaniora"))) warning("'Humaniora' is missing in variable 'utbgrp'.", call. = FALSE)
  if(!all(c("F\u00F6rbund") %in% levels(AEAdf$avisering))) warning("'F\u00F6rbund' is missing in variable 'avisering'.", call. = FALSE)
  if(!any(c("Direkt", "Annat") %in% levels(AEAdf$avisering))) warning("'Direkt' and 'Annat' is missing in variable 'avisering'.", call. = FALSE)
  if(!all(c("X") %in% levels(AEAdf$ers))) warning("'X' is missing in variable 'ers'.", call. = FALSE)
  if(!all(c("X") %in% levels(AEAdf$infopost))) warning("'X' is missing in variable 'infopost'.", call. = FALSE)
  
  # Corrections
  levels(AEAdf$lan)[levels(AEAdf$lan) == ""] <- "Ok\u00E4nd"
  
  # Setting addition class
  class(AEAdf) <- c("AEA_data", "data.frame")
  
  # Do makro checks of data
  if(table(AEAdf$avisering)["F\u00F6rbund"] < 1000) warning("F\u00F6rbundsaviseringar < 1000")
  
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

#' @title
#' Automatically find out variable name
#' 
#' @param x statX variable to check
#' 
find_stat_var_name<- function(x){
  res <- "ERROR"
  if(all(c("Kommunal", "Statlig", "Privat") %in% levels(x))) res <- "sektor"
  if(all(c("Sjukskriven", "Studerande", "Pensionerad") %in% levels(x))) res <- "anst"
  if(any(stringr::str_detect(string = levels(x), pattern = "Univ"))) res <- "utbniva"
  if(all(c("Bibliotekarieutbildning", "Arkeologi") %in% levels(x))) res <- "utbgrp"
  if(all(c("Bibliotek", "Museum", "Kommunikation") %in% levels(x))) res <- "intrgrp"
  if(res == "ERROR") warning("Could not find variable automatically.")
  res
}
