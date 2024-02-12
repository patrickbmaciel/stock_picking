#' @name rename_data
#' @description renomea colunas da base dados
#' @param base dataframe com dados de fiis ou ações

rename_data <- function(base) {
  
  # 1) Convertendo os nomes das colunas para minúsculas
  colnames(base) <- tolower(colnames(base))
  
  # 2) Removendo os espaços nos nomes das colunas
  colnames(base) <- gsub(" ", "", colnames(base))
  
  # 3) Substituindo pontos por underscore nos nomes das colunas
  colnames(base) <- gsub("\\.(?=[^[:alnum:]]|$)", "_", colnames(base), perl = TRUE)
  
  # 4) Retornando base
  return(base)
  
}