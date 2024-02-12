#' @name gera_precos
#' @description gera preços justos a partir do método de Graham e Bazin, além de
#' calcular a média desses preços
#' @param base dataframe contendo os dados a serem manipulados
#' @param liq_corrente_aceitavel valor aceitável para a liquidez corrente
#' @param div_desejado valor desejado para a taxa de dividendo yield

gera_precos <- function(base, liq_corrente_aceitavel, div_desejado) {
  
  # 1) Obtendo constante de Graham descontada
  constante_graham <- (mean(base$pl) * 0.9) * liq_corrente_aceitavel
  
  # 2) Manipulando dados: criando variáveis para chegar no valor justo estimado
  acoes_precos <- 
    base %>% 
    dplyr::mutate(lpa = preco / pl,
                  vpa = preco / pvp,
                  preco_graham = sqrt(constante_graham * lpa * vpa),
                  div_anual = preco * (div_yield / 100),
                  preco_bazin = div_anual / div_desejado,
                  preco_justo = round((preco_graham + preco_bazin) / 2, 2),
                  dif_preco = preco_justo - preco,
                  potencial_valorizacao = round(((preco_justo - preco) / preco) * 100, 2)) %>% 
    dplyr::select(acao, preco, preco_justo, potencial_valorizacao, everything())
  
  # 3) Selecionando colunas
  acoes_precos <- acoes_precos[1:14]
  
  # 4) Retornando base
  return(acoes_precos)
  
}