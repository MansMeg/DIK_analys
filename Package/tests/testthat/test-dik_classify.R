# Test suite for utils functions

context("dik_classify()")

test_that(desc="",{    
  test_vec_utb = c("Bildpedagogik", "bildpedagogik", "MKV: Design och formgivning")
  res_vec_utb = factor(c("Humaniora", "Humaniora", "Kommunikation och media"))
  test_vec_int = c("MKV: Kommunikationsvetenskap", "Kultur")
  res_vec_int = factor(c("Kommunikation", "Kultur"))
  
  
  expect_that(dik_classify(x = test_vec_utb, type = "utb"), not(gives_warning("")))
  expect_identical(dik_classify(x = test_vec_utb, type = "utb"), res_vec_utb)
  
  expect_that(dik_classify(x = test_vec_int, type = "int"), not(gives_warning("")))
  expect_identical(dik_classify(x = test_vec_int, type = "int"), res_vec_int)
  
  class_files <- c("Utbildningsgrupper.csv", "Intressegrupper.csv")
  class_url <- "https://raw.githubusercontent.com/MansMeg/DIK_analys/master/Classification/"

  for(class_file in class_files){
    temp_file <- paste0(tempdir(), "/", class_file)
    request <- httr::GET(paste0(class_url, class_file))
    httr::stop_for_status(request)
    writeBin(httr::content(request, type = "raw"), temp_file)
  }
  
  expect_that(dik_classify(x = test_vec, type = "utb", source_folder = tempdir()), not(gives_warning("")))
  expect_identical(dik_classify(x = test_vec, type = "utb", source_folder = tempdir()), res_vec_utb)  
  
  expect_that(dik_classify(x = test_vec_int, type = "int", source_folder = tempdir()), not(gives_warning("")))
  expect_identical(dik_classify(x = test_vec_int, type = "int", source_folder = tempdir()), res_vec_int)
  
  expect_error(dik_classify(x = test_vec_int, type = "int", source_folder = "/"))
  expect_error(dik_classify(x = test_vec_utb, type = "utb", source_folder = "/"))
  
})
