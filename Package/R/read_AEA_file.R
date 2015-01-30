#' @title
#' Read in DIK unemployment files from AEA
#' 
#' @param file_path
#' Path to an AEA file
#' 
#' @description
#' All files are read in to R and put in one data.frame, checks that the file is correct
#' is conducted.
#' 
#' @return
#' \code{data.frame} of class AEA_data.
#' 
#' @export
#' 
read_AEA_file <- function(file_path){
  if(!file.exists(file_path)) stop("File does not exist.")
  
  AEAdf <- read.csv(file = file_path, 
                    fileEncoding="cp1252", stringsAsFactors=TRUE)
  
  # File checks
  var_names <- 
    c("manad", "forbund", "alder", "kon", "lan", "ers", "utbprogram", "infopost",
      "avisering", "stat1", "stat2", "stat3", "stat4", "stat5")
  var_exist <- var_names %in% names(AEAdf)
  if(!all(var_exist)) warning(paste0("The following variables is missing: \n'", 
                                     paste(var_names[!var_exist], collapse = "', '"), "'"), call. = FALSE)
  
  if(!all(c("Studerande") %in% levels(AEAdf$stat1))) warning("'Studerande' is missing in variable 'stat1'.", call. = FALSE)
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