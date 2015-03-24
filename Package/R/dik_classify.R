#' @title
#' Classifies based on DIK interest groups
#' 
#' @param x variable to classify
#' @param type which classification to use ("utbildningsgrupp" or "intressegrupp")
#' 
#' @details
#' The functions classifies using the classifiers found here:
#' \url{https://github.com/MansMeg/DIK_analys/tree/master/Classification}
#' 
#' @export
dik_classify <- function(x, type = c("utbildningsgrupp", "intressegrupp")){
  x <- as.factor(x)
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
  class_table <- read.csv(temp_file)
  
  class_table[,2] <- tolower(class_table[,2])
  names(class_table)[2] <- "label"
  
  add_label_df <- data.frame(rowno=1:length(levels(x)), Label = stringr::str_trim(levels(x)), label = tolower(stringr::str_trim(levels(x))), stringsAsFactors = FALSE)
  add_label_df <- merge(add_label_df, class_table, all.x = TRUE)
  not_in_class <- is.na(add_label_df[,4])
  
  if(any(not_in_class)) {
    warning("The following classes has not been classified:\n'",
            paste(add_label_df$Label[not_in_class], collapse="'\n'"), "'")
    add_label_df[not_in_class, 4] <- "NOT CLASSIFIED"
  }
  levels(x) <- add_label_df[order(add_label_df$rowno), 4]
  factor(as.character(x))
}