#' @name filter_indicators
#' @description filtra base de dados com ações ou fiis a partir de indicadores específicos
#' @param base dataframe contendo os dados a serem filtrados
#' @param div_yield_min valor mínimo para a taxa de dividendo yield
#' @param pvp_max valor máximo para o índice p/vp
#' @param pl_max valor máximo para o índice p/l
#' @param cagr_min valor mínimo para a taxa de crescimento anual composta
#' @param roe_min valor mínimo para o retorno sobre o patrimônio líquido
#' @param ll_yield_min valor mínimo para o lucro líquido yield
#' @param vacancia_media_max valor máximo para a vacância média

filter_indicators <- function(base, # base de dados
                              div_yield_min, pvp_max, # indicadores em comum
                              pl_max, cagr_min, roe_min, # indicadores de ações
                              ll_yield_min, vacancia_media_max) { # indicadores de fiis
  
  # 1) Filtrando indicadores de ações
  if ("pl" %in% colnames(base)) {
    
    base_filter <-
      base %>% 
      dplyr::filter(div_yield >= div_yield_min,
                    pl <= pl_max,
                    pvp <= pvp_max,
                    cagr_cinco_anos >= cagr_min,
                    roe >= roe_min)
    
    # 2) Filtrando indicadores de fiis
  } else if ("ll_yield" %in% colnames(base)) {
    
    base_filter <- 
      base %>% 
      dplyr::filter(ll_yield >= ll_yield_min,
                    div_yield >= div_yield_min,
                    vacancia_media <= vacancia_media_max,
                    pvp <= pvp_max)
    
  }
  
  
  # 3) Retornando base
  return(base_filter)
  
}