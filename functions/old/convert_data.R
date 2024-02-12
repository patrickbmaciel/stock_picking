#' @name convert_data
#' @description converte as colunas numéricas da base dados
#' @param base dataframe com dados de ações brasileiras

convert_data <- function(base, 
                         colunas = c("preco", "div_yield", "pl", "pvp", "pebit", "cagr_cinco_anos", "roe", "roic", "liq_corrente", "margem_liq")) {
  
  for (col in colunas) {
    
    # 1) Removendo caracteres não numéricos, substituindo vírgulas por pontos e converte para numérico
    base[[col]] <- as.numeric(str_replace_all(base[[col]], "[^0-9.,-]", "") %>% str_replace_all(., ",", "."))
    
  }
  
  # 2) Retornando base
  return(base)
  
}