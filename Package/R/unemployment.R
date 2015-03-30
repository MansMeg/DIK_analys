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
#' Calculate all statistics
#' 
#' @param AEA_data
#' Data set from AEA read into R.
#' 
#' @description
#' Calculates all statistics of interest and store it as list.
#' 
#' @export
#' 
calc_dik_stat <- function(AEA_data){
  check_class(AEA_data, "AEA_data")

  dik_stat <- list()  
  dik_stat[["Month"]] <- as.character(AEA_data$manad[1])
  
  # Medlemmar i AEA
  dik_stat[["Medlemmar_ej_65_ar_fyllda"]] <- 
    calc_member_aea_stat(AEA_data[AEA_data$alder < 65, ])
  dik_stat[["Medlemmar_ej_65_ar_fyllda_ej_stud"]] <- 
    calc_member_aea_stat(AEA_data = AEA_data[AEA_data$alder < 65 & AEA_data$stat1 != "Studerande", ])
  
  # Ersättningstagare
  # Remove nonmembers of AEA
  dik_stat[["Ers_aktstod_anststod"]] <-
    calc_ers_stat(AEA_data[AEA_data$alder < 65 & AEA_data$avisering %in% c("Annat", "Direkt", "Förbund"), ])
  AEA_member_data <- AEA_data[AEA_data$alder < 65 & AEA_data$stat1 != "Studerande" & AEA_data$avisering %in% c("Annat", "Direkt", "Förbund"), ]
  dik_stat[["Ers_aktstod_anststod_ej_stud"]] <-
    calc_ers_stat(AEA_member_data)

  arbmark <- calc_arbmarkn_stat(AEA_data)
  dik_stat[["Arbetsmarknadspolitiska_program_1_ej_stud"]] <-  
    arbmark[[1]]
  dik_stat[["Arbetsmarknadspolitiska_program_2_ej_stud"]] <-  
    arbmark[[2]]
  
  dik_stat[["Ers_efter_kon_Man_ej_stud"]] <-
    calc_ers_stat(AEA_member_data[AEA_member_data$kon == "M", ])
  dik_stat[["Ers_efter_kon_Kvinna_ej_stud"]] <-
    calc_ers_stat(AEA_member_data[AEA_member_data$kon == "K", ])
  dik_stat[["Ers_efter_lan_ej_stud"]] <-
    do.call(rbind, lapply(split(x = AEA_member_data, AEA_member_data$lan), calc_ers_stat))
  
  age_cat <- cut(AEA_member_data$alder,breaks = c(0, seq(25, 65, by = 5)), right = FALSE)
  levels(age_cat) <- 
    c("< 25", paste(seq(25,60,5), seq(29,64,5), sep = "-"))
  dik_stat[["Ers_efter_alder_ej_stud"]] <-
    do.call(rbind, lapply(split(x = AEA_member_data, age_cat), calc_ers_stat))
  
  dik_stat[["Ers_efter_Intrgr_ej_stud"]] <-
    do.call(rbind, lapply(split(x = AEA_member_data, dik_classify(x = AEA_member_data$stat4, type = "intressegrupp")), calc_ers_stat))
  dik_stat[["Ers_efter_Utbgr_ej_stud"]] <-
    do.call(rbind, lapply(split(x = AEA_member_data, dik_classify(AEA_member_data$stat3, "utbildningsgrupp")), calc_ers_stat))  
  dik_stat[["Ers_efter_UtbNiv_ej_stud"]] <-
    do.call(rbind, lapply(split(x = AEA_member_data, AEA_member_data$stat2), calc_ers_stat))  

  class(dik_stat) <- c("dik_stat", "list")
  return(dik_stat)
}

#' @title
#' Calculates labor force program statistics
#' 
#' @param AEA_data
#' AEA data set
#' 
#' @description
#' Calculates labor force program statistics
#' 
calc_arbmarkn_stat <- function(AEA_data){
  
  arbmark <- table(AEA_data$utbprogram)

  arb_program1 <-
    data.frame(program = names(arbmark), antal = as.vector(arbmark))[-1, ,drop=FALSE]
  arb_program1 <- rbind(arb_program1, 
                       data.frame(program = "totalt", antal = sum(arb_program1$antal)))

  arb_program2 <- 
    data.frame(totalt = arb_program1[arb_program1$program == "totalt", "antal"])
  arb_program2$ers_tagare <- sum(AEA_data$utbprogram != "" & AEA_data$ers == "X")
  arb_program2$arb_m_stod <- sum(AEA_data$utbprogram != "" & AEA_data$ers != "X" & AEA_data$infopost != "X")
  arb_program2$i_prg_utan_ers <- arb_program2$totalt - arb_program2$ers_tagare
  arb_program2$aktivitetsers <- arb_program2$totalt - arb_program2$ers_tagare - arb_program2$arb_m_stod
  arb_program2$jug <- arb_program1[arb_program1$program == "Jobb och utvecklingsgaranti", "antal"]
  arb_program2$fas3 <- arb_program1[arb_program1$program == "Jobb o utvecklingsgaranti fas 3", "antal"]
  arb_program2$ovriga <- arb_program2$totalt - arb_program2$arb_m_stod - arb_program2$jug - arb_program2$fas3
  arb_program2 <- arb_program2[, c(1, 4, 5, 2, 3, 6, 7, 8)]

  res <- list(arb_program1, arb_program2)
  return(res)  
}



#' @title
#' Calculates membership statistics
#' 
#' @param AEA_data
#' AEA data set
#' 
#' @description
#' Calculate membership statistics
#' 
calc_member_aea_stat <- function(AEA_data){

  av <- table(AEA_data$avisering)
  if("Direkt" %in% names(av)) nam <- "Direkt" else nam <- "Annat"
  
  res <- 
    data.frame(direktaviserade = av[nam], 
               forbundsaviserade = av["Förbund"])
  res$tot_i_dik_och_aea <- res$direktaviserade + res$forbundsaviserade
  res$antal_medlemmar_dik <- nrow(AEA_data)
  res$andel_aea_anslutna <- res$tot_i_dik_och_aea / res$antal_medlemmar_dik
  res$andel_direktaviserade <- res$direktaviserade / res$tot_i_dik_och_aea
  
  rownames(res) <- NULL
  return(res)  
}

#' @title
#' Calculates allowance statistics
#' 
#' @param AEA_data
#' AEA data set
#' 
#' @description
#' Calculate allowance statistics for the whole data.
#' 
calc_ers_stat <- function(AEA_data){

  res <- 
    data.frame(tot_i_dik_och_aea = nrow(AEA_data))
  res$ers_tagare_antal <- sum(AEA_data$ers=="X")
  res$ers_tagare_andel <- res$ers_tagare_antal / res$tot_i_dik_och_aea
  res$akt_stod_antal <- sum(AEA_data$utbprogram != "" & AEA_data$ers != "X" & AEA_data$infopost == "X")
  res$akt_stod_andel <- res$akt_stod_antal / res$tot_i_dik_och_aea
  res$ers_akt_stod_antal <- res$ers_tagare_antal + res$akt_stod_antal
  res$ers_akt_stod_andel <- res$ers_akt_stod_antal / res$tot_i_dik_och_aea
  res$anst_m_stod_antal <- sum(AEA_data$utbprogram != "" & AEA_data$ers != "X" & AEA_data$infopost != "X")
  res$anst_m_stod_andel <- res$anst_m_stod_antal / res$tot_i_dik_och_aea
  
  rownames(res) <- NULL
  return(res)  
}

