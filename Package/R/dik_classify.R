#' @title
#' Classifies based on DIK interest groups
#' 
#' @param x variable to classify
#' @param type which classification to use ("utbildningsgrupp" or "intressegrupp")
#' @param source_folder Folder that contain Utbildningsgrupper.csv and Intressegrupper.csv
#' 
#' @details
#' The functions classifies using the classifiers found here:
#' \url{https://github.com/MansMeg/DIK_analys/tree/master/Classification}
#' 
#' @export
dik_classify <- function(x, type = c("utbildningsgrupp", "intressegrupp"), source_folder = NULL){
  nas <- is.na(x)
  if(any(nas)) {
    warning(paste0(sum(nas), " missing values in '", type, "' set to 'Uppgift saknas'.") , call. = FALSE)
    x[nas] <- "Uppgift saknas"
  }
  x <- as.factor(x)
  
  class_files <- c("Intressegrupper.csv", "Utbildningsgrupper.csv")
  
  if(is.null(source_folder)){
    if(substr(type[1], 1, 3) == "utb"){
      class_url <- "https://raw.githubusercontent.com/MansMeg/DIK_analys/master/Classification/Utbildningsgrupper.csv"
    } else if (substr(type[1], 1, 3) == "int"){
      class_url <- "https://raw.githubusercontent.com/MansMeg/DIK_analys/master/Classification/Intressegrupper.csv"
    }
    
    temp_file <- tempfile()
    on.exit(unlink(temp_file))
    request <- httr::GET(class_url)
    httr::stop_for_status(request)
    writeBin(httr::content(request, type = "raw"), temp_file)
    class_table <- read.csv(temp_file, fileEncoding = "utf8")
    
  } else {
    # Check source folder
    if(substr(type[1], 1, 3) == "utb"){
      if(!"Utbildningsgrupper.csv"%in%dir(source_folder)) stop("Utbildningsgrupper.csv is missing in source folder.")
      class_table <- read.csv(paste0(source_folder, "/Utbildningsgrupper.csv"), fileEncoding = "utf8")
    } else if (substr(type[1], 1, 3) == "int"){
      if(!"Intressegrupper.csv"%in%dir(source_folder)) stop("Utbildningsgrupper.csv is missing in source folder.")
      class_table <- read.csv(paste0(source_folder, "/Intressegrupper.csv"), fileEncoding = "utf8")
    }
  }
  
  class_table[,2] <- tolower(class_table[,2])
  names(class_table)[2] <- "label"
  
  add_label_df <- data.frame(rowno=1:length(levels(x)), 
                             Label = stringr::str_trim(levels(x)), 
                             label = tolower(stringr::str_trim(levels(x))), stringsAsFactors = FALSE)
  add_label_df <- merge(add_label_df, class_table, by.x="label", by.y="label", all.x = TRUE)
  not_in_class <- is.na(add_label_df[,4])

  # Warnings
  dup <- class_table[,2][duplicated(class_table[,2])]
  if(length(dup)>0) warning("The following duplicates exist in classifications:\n", paste(dup,collapse = "\n"))
  
  if(any(not_in_class)) {
    warning("The following classes has not been classified:\n'",
            paste(add_label_df$Label[not_in_class], collapse="'\n'"), "'")
    add_label_df[not_in_class, 4] <- "NOT CLASSIFIED"
  }
  levels(x) <- add_label_df[order(add_label_df$rowno), 4]
  factor(as.character(x))
}