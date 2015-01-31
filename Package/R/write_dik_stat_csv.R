#' @title
#' Write statistics to db (csv-files)
#' 
#' @param dik_stat A dik_stat object calculated with \code{aggr_unempl_data}.
#' 
#' @description
#' Writes all statistics in a dik_stat object to different csv-files.
#' 
#' @export
write_dik_stat_csv <- function(dik_stat, db_path){
  check_class(dik_stat, "dik_stat")
  yearmonth <- dik_month_conv(dik_stat$Month)
  dik_stat$Month <- NULL
  months <- c("januari", "februari", "mars", "april", "maj", "juni", "juli", "augusti", 
              "september", "oktober", "november", "december")
  
  for(i in seq_along(dik_stat)[-1]){ 
    temp_df <- read.csv(paste0(db_path,names(dik_stat)[i]))
    temp_df <- rbind(temp_df, cbind(yearmonth, dik_stat[[i]]))
    temp_df <- temp_df[order(temp_df$year, dik_month_strings_to_factor(temp_df$month)),]
    temp_df <- temp_df[!duplicated(temp_df),]
    write.csv(temp_df, paste0(db_path, names(dik_stat)[i]), row.names=FALSE)
  }  
}

dik_month_to_strings <- function(x){
  months <- c("januari", "februari", "mars", "april", "maj", "juni", "juli", "augusti", 
              "september", "oktober", "november", "december")
  output <-   
    data.frame(year = as.numeric(substr(dik_stat$Month,1,4)),
               month = months[as.numeric(substr(dik_stat$Month,5,6))])
  output  
}

dik_month_strings_to_factor <- function(x){
  res <- integer(length(x))
  months <- c("januari", "februari", "mars", "april", "maj", "juni", "juli", "augusti", 
              "september", "oktober", "november", "december")
  for(i in seq_along(x)){
    res[i] <- which(months %in% x[i])
  }
  factor(res, labels = months)
}


