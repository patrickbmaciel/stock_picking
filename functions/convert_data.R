#' @name convert_data
#' @description converte as colunas numéricas da base dados
#' @param base dataframe com dados de fiis ou ações

convert_data <- function(base, nome_base = as.character(substitute(base))) {
  
  # 1) Verificando se os dados são de ações ou fiis
  if (grepl("acoes", nome_base)) {
    
    colunas <- c("preco", "div_yield", "pl", "pvp", "pebit", "cagr_cinco_anos", "roe", "roic", "liq_corrente", "margem_liq")
    
  } else if (grepl("fiis", nome_base)) {
    
    colunas <- c("preco", "ll_yield", "div_yield", "qtd_imoveis", "vacancia_media", "pvp")
    
    base <- 
      base %>% 
      dplyr::mutate(valor_mercado = as.numeric(str_replace_all(valor_mercado, "\\.", "")))
    
  }
  
  # 2) Removendo caracteres não numéricos, substituindo vírgulas por pontos e converte para numérico
  for (col in colunas) {
    
    base[[col]] <- as.numeric(str_replace_all(base[[col]], "[^0-9.,-]", "") %>% str_replace_all(., ",", "."))
    
  }
  
  # 3) Retornando base
  return(base)
  
}