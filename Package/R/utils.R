#' @title
#'   Convert month and year to lubridate format
#' 
#' @param year
#'   Year
#' @param month
#'   Month as text (ex. januari).
#' @param day
#'   Day to set (default is "01")
#' 
#' @description
#' Creates a date variable
#' 
#' @return
#'  vector in lubridate format
#'  
#' @export
to_date <- function(year, month, day = "01"){
  month <- as.character(month)
  month_abbr <- c("jan", "feb", "mar", "apr", "maj", "jun", "jul", "aug", "sep", "okt", "nov", "dec")
  month_num <- unlist(lapply(tolower(stringr::str_sub(month,1,3)), FUN=function(X) which(month_abbr %in% X)))
  return(lubridate::ymd(paste(year, month_num, day, sep="-")))
}
