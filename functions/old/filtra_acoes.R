#' @name filtra_acoes
#' @description filtra base de dados com ações brasileiras a partir de indicadores específicos
#' @param base dataframe contendo os dados a serem filtrados
#' @param div_yield_min valor mínimo para a taxa de dividendo yield
#' @param pl_max valor máximo para o índice p/l
#' @param pvp_max valor máximo para o índice p/vp
#' @param cagr_min valor mínimo para a taxa de crescimento anual composta
#' @param roe_min valor mínimo para o retorno sobre o patrimônio líquido
#' @param liq_corrente_min valor mínimo para a liquidez corrente

filtra_acoes <- function(base, div_yield_min, pl_max, pvp_max, cagr_min, roe_min) {
  
  # 1) Filtrando base de dados com base nas premissas
  acoes_filter <-
    base %>% 
    dplyr::filter(div_yield >= div_yield_min,
                  pl <= pl_max,
                  pvp <= pvp_max,
                  cagr_cinco_anos >= cagr_min,
                  roe >= roe_min)
  
  # 1) Retornando base
  return(acoes_filter)
  
}