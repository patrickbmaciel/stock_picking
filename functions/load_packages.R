#' @name load_packages
#' @description carrega todos os pacotes necessários do pipeline

# 1) Definindo os pacotes
packages <- c("dplyr", "purrr", "stringr", "rvest", "XML")

# 2) Carregando os pacotes
sapply(packages, library, character.only = TRUE)
