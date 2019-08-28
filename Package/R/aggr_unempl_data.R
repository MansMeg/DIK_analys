#' @title
#' Calculate all statistics
#' 
#' @param AEA_data
#' Data set from AEA read into R.
#' @param classification_source_folder
#' Folder where the classification files is located
#' 
#' @description
#' Calculates all statistics of interest and store it as list ready to append to data files.
#' 
#' @export
aggr_unempl_data <- function(AEA_data, classification_source_folder = NULL){
  checkmate::assert_class(AEA_data, "AEA_data")

  dik_stat <- list()  
  dik_stat[["Month"]] <- as.character(AEA_data$manad[1])
  
  # Medlemmar i AEA
  if(checkmate::test_names(names(AEA_data), must.include = c("avisering", "alder"))){
    dik_stat[["medlemmar_AEA.csv"]] <- 
      calc_member_aea_stat(AEA_data[AEA_data$alder < 65, ])[c(1,2,4)]
    names(dik_stat[["medlemmar_AEA.csv"]]) <- c("Direktaviserade_AEA","Forbundsaviserade_AEA","Medlemmar_DIK_upp_till_65")
  }

  if(checkmate::test_names(names(AEA_data), must.include = c("avisering", "alder", "anst"))){
    dik_stat[["medlemmar_AEA_ej_stud.csv"]] <- 
      calc_member_aea_stat(AEA_data = AEA_data[AEA_data$alder < 65 & AEA_data$anst != "Studerande", ])[c(1,2,4)]
    names(dik_stat[["medlemmar_AEA_ej_stud.csv"]]) <- c("Direktaviserade_AEA","Forbundsaviserade_AEA","Medlemmar_DIK_upp_till_65")
  }

  # Ersattningstagare
  
  # Remove nonmembers of AEA
  if(checkmate::test_names(names(AEA_data), must.include = c("avisering", "alder", "anst"))){
    AEA_member_data <- AEA_data[AEA_data$alder < 65 & AEA_data$anst != "Studerande" & AEA_data$avisering %in% c("Annat", "Direkt", "F\u00F6rbund"), ]
  }
  
  if(exists("AEA_member_data")){
    if(checkmate::test_names(names(AEA_member_data), must.include = c("ers", "utbprogram", "infopost"))){
      dik_stat[["ers_ej_stud.csv"]] <-
        calc_ers_stat(AEA_member_data)[c(2,4,8)]
      names(dik_stat[["ers_ej_stud.csv"]]) <- c("ers_tagare","akt_stod","anst_m_stod")
    }
  }
  
  if(checkmate::test_names(names(AEA_member_data), must.include = c("utbprogram", "ers", "infopost"))){
    arbmark <- calc_arbmarkn_stat(AEA_data)
    dik_stat[["arb_prgm_a.csv"]] <-  
      arbmark[[1]][-nrow(arbmark[[1]]),]
    colnames(dik_stat[["arb_prgm_a.csv"]]) <- c("arb_mark_prgm","antal")
    
    dik_stat[["arb_prgm_b.csv"]] <-  
      arbmark[[2]]
    colnames(dik_stat[["arb_prgm_b.csv"]]) <- 
      c("antal","prgm_utan_ers","akt_stod","ers_tagare_i_akt_stod","anst_m_stod","jug","fas3","ovriga")
  }

  # Ers. by sex
  if(exists("AEA_member_data")){
    if(checkmate::test_names(names(AEA_member_data), must.include = c("ers", "utbprogram", "infopost", "kon"))){
      ers_M <-
        calc_ers_stat(AEA_member_data[AEA_member_data$kon == "M", ])[c(1,2,4,8)]
      names(ers_M) <- c("AEA_ansl_M","ers_tagare_M","akt_stod_M","anst_m_stod_M")
      ers_K <-
        calc_ers_stat(AEA_member_data[AEA_member_data$kon == "K", ])[c(1,2,4,8)]
      names(ers_K) <- c("AEA_ansl_K","ers_tagare_K","akt_stod_K","anst_m_stod_K")
      dik_stat[["ers_by_sex.csv"]] <-
        cbind(ers_M, ers_K)[,c(1,5,2,6,3,7,4,8)]
    }
  }

  # Counties
  if(exists("AEA_member_data")){
    if(checkmate::test_names(names(AEA_member_data), must.include = c("ers", "utbprogram", "infopost", "lan"))){
      cnty <-
        do.call(rbind, lapply(split(x = AEA_member_data, AEA_member_data$lan), calc_ers_stat))[,c(1,2,4,8)]
      cnty <- cbind(rownames(cnty), cnty)
      colnames(cnty) <- c("county","antal","ers_tagare","akt_stod","anst_m_stod")
      rownames(cnty) <- NULL
      dik_stat[["ers_by_county.csv"]] <- cnty
    }
  }

  if(exists("AEA_member_data")){
    if(checkmate::test_names(names(AEA_member_data), must.include = c("ers", "utbprogram", "infopost", "alder"))){
      # Age
      age_cat <- cut(AEA_member_data$alder, breaks = c(0, seq(25, 65, by = 5)), right = FALSE)
      levels(age_cat) <- 
        c("< 25", paste(seq(25,60,5), seq(29,64,5), sep = "-"))
      ages <-
        do.call(rbind, lapply(split(x = AEA_member_data, age_cat), calc_ers_stat))[,c(1,2,4,8)]
      ages <- cbind(rownames(ages), ages)
      colnames(ages) <- c("age_group","antal","ers_tagare","akt_stod","anst_m_stod")
      rownames(ages) <- NULL
      dik_stat[["ers_by_age.csv"]] <- ages
    }
  }

  if(exists("AEA_member_data")){
    if(checkmate::test_names(names(AEA_member_data), must.include = c("ers", "utbprogram", "infopost", "intrgrp"))){
      # Intrest group
      AEA_member_data$intrgrp_class <- dik_classify(x = AEA_member_data$intrgrp, type = "intressegrupp", source_folder = classification_source_folder)
      intr_group <-
        do.call(rbind, lapply(split(x = AEA_member_data, AEA_member_data$intrgrp_class), calc_ers_stat))
      intr_group <- cbind(rownames(intr_group), intr_group[,c(1,2,4,8)])
      colnames(intr_group) <- c("intressegrupp","antal","ers_tagare","akt_stod","anst_m_stod")
      rownames(intr_group) <- NULL
      dik_stat[["ers_by_interest_group.csv"]] <- intr_group
    }
  }
  
  if(exists("AEA_member_data")){
    if(checkmate::test_names(names(AEA_member_data), must.include = c("ers", "utbprogram", "infopost", "intrgrp"))){
      # Utb.inriktning 
      AEA_member_data$utbgrp_class <- dik_classify(x = AEA_member_data$utbgrp, type = "utbildningsgrupp", source_folder = classification_source_folder)
      utb_group <-
        do.call(rbind, lapply(split(x = AEA_member_data, AEA_member_data$utbgrp_class), calc_ers_stat))  
      utb_group <- cbind(rownames(utb_group), utb_group[,c(1,2,4,8)])
      colnames(utb_group) <- c("utb_grupp","antal","ers_tagare","akt_stod","anst_m_stod")
      rownames(utb_group) <- NULL
      dik_stat[["ers_by_education.csv"]] <- utb_group
    }
  }
  
  if(exists("AEA_member_data")){
    if(checkmate::test_names(names(AEA_member_data), must.include = c("ers", "utbprogram", "infopost", "utbniva"))){
      # Utb.inriktning 
      utb_niv <-
        do.call(rbind, lapply(split(x = AEA_member_data, AEA_member_data$utbniva), calc_ers_stat))  
      utb_niv <- cbind(rownames(utb_niv), utb_niv[,c(1,2,4,8)])
      colnames(utb_niv) <- c("utb_niva","antal","ers_tagare","akt_stod","anst_m_stod")
      rownames(utb_niv) <- NULL
      dik_stat[["ers_by_education_level.csv"]] <- utb_niv
    }
  }

  class(dik_stat) <- c("dik_stat", "list")
  return(dik_stat)
}
