# 0) Configurações iniciais -----------------------------------------------

# 0.1) Limpando R
rm(list = ls())
cat("\014")

# 0.2) Importando funções
purrr::map(paste0("functions/", list.files("functions/", pattern = ".R$")), source)

# 0.3) Importando base de dados
acoes <- read_data(url = "https://www.fundamentus.com.br/resultado.php")

# 0.4) Tratando base de dados
acoes_rename <- rename_data(base = acoes)

# 0.5) Selecionando colunas
acoes_select <- 
  acoes_rename %>% 
  dplyr::select(
    # Variáveis principais
    acao = papel, preco = "cotação", div_yield = div.yield,
    # Indicadores de valuation
    pl = "p/l", pebit = "p/ebit", pvp = "p/vp", cagr_cinco_anos = "cresc.rec.5a",
    # Indicadores de lucratividade
    roe, roic,
    # Indicadores de endividamento
    liq_corrente = liq.corr_, margem_liq = mrg.líq_, div_bruta_patrimonio = "dív.brut/patrim_")

# 0.6) Tratando dados
acoes_convert <- 
  convert_data(base = acoes_select) %>% 
  stats::na.omit() %>% 
  dplyr::filter(pl >= 0)

# 1) Análise de indicadores -----------------------------------------------

# Indicadores:
# - P/L: medida de avaliação que compara o preço da ação com o lucro por ação da 
# empresa.
# - P/VP: compara o preço da ação com o valor patrimonial por ação, sendo o 
# valor patrimonial correspondente ao valor contábil da empresa dividido pelo 
# número de ações, ou seja, indica quanto os investidores estão dispostos a pagar
# em relação ao valor contábil da empresa.
# - CAGR: representa a taxa de crescimento média anual de um investimento ao 
# longo de um determinado período, indicando o crescimento médio anual dos lucros 
# nos últimos cinco anos.
# - ROE: medida de rentabilidade que compara o lucro líquido de uma empresa com 
# seu patrimônio líquido, indicando a eficiência com que a empresa está utilizando 
# o patrimônio líquido para gerar lucros.
# - ROIC: leva em consideração o capital total investido, incluindo dívidas, 
# indicando a eficiência da empresa em gerar retorno sobre todo o capital 
# investido, incluindo dívidas.
# - Liquidez Corrente: medida de liquidez que compara os ativos circulantes 
# (ativos de curto prazo) com os passivos circulantes (dívidas de curto prazo), 
# indicando a capacidade da empresa de pagar suas dívidas de curto prazo com seus
# ativos de curto prazo.
# - Margem Líquida: proporção entre o lucro líquido e a receita total da empresa, 
# sendo expressa pela porcentagem de receitas que se convertem em lucro líquido, 
# indicando a eficiência operacional da empresa.
# - Dívida Bruta / Patrimônio: resultado maior que 1 sugere que a empresa tem mais 
# dívidas do que patrimônio líquido. Isso pode indicar uma situação de maior 
# alavancagem financeira, o que implica um risco maior.

# 1.1) Filtrando ações: abordagem leve
# acoes_filter <- filter_indicators(acoes_convert,
#                                   div_yield_min = 0,
#                                   pl_max = 50,
#                                   pvp_max = 30,
#                                   cagr_min = 0,
#                                   roe_min = 5)

# 1.2) Filtrando ações: abordagem moderada
acoes_filter <- filter_indicators(acoes_convert,
                                  div_yield_min = 6,
                                  pl_max = 30,
                                  pvp_max = 10,
                                  cagr_min = 10,
                                  roe_min = 10)

# 1.3) Filtrando ações: abordagem rígida
# acoes_filter <- filter_indicators(acoes_convert,
#                                   div_yield_min = 12,
#                                   pl_max = 10,
#                                   pvp_max = 5,
#                                   cagr_min = 20,
#                                   roe_min = 20)

# 2) Calculando preços justos ---------------------------------------------

# Graham:
# - √(22,5 x LPA x VPA)
# - O ativo circulante deve ser 1,5 vezes maior do que o passivo circulante. Já 
# o  P/L deve ser, no máximo, 15 vezes. Ao multiplicar ambos, (15 x 1,5), obtemos 
# o resultado 22,5. Em outras palavras, o investidor pode adquirir empresas com 
# um P/L caro, contanto que a relação ativo e passivo seja menor, de no máximo 1,5x.

# Bazin:
# Calcule o preço justo: Divida o dividendo anual por ação pelo dividend yield 
# desejado. Neste caso, divida R$ 3,00 por 0,06 (6%). O resultado é R$ 50,00. 
# Esse valor representa o preço justo da ação segundo o Método Bazin.

# 2.1) Encontrando preços justos
acoes_preco <- gera_precos(base = acoes_filter,
                           liq_corrente_aceitavel = 1,
                           div_desejado = 0.12)

# 3) Importando carteira --------------------------------------------------

# 3.1) Definindo ações na carteira
carteira <- c("PRIO3", "WEGE3", "BPAC11", "BBAS3", "ITSA4", "ARZZ3", "TOTS3", 
              "ALUP11", "TAEE11", "RENT3", "INBR32")

# 3.2) Filtrando base de dados
acoes_carteira <- 
  acoes_convert %>% 
  dplyr::filter(acao %in% carteira)

# 2.1) Encontrando preços justos
carteira_preco <- gera_precos(base = acoes_carteira,
                              liq_corrente_aceitavel = 1,
                              div_desejado = 0.12)

# 4) Análise final --------------------------------------------------------

# 4.1) Agrupando dataframes
acoes_final <- 
  rbind(acoes_preco %>% mutate(carteira = "não"),
        carteira_preco %>% mutate(carteira = "sim")) %>% 
  dplyr::filter(potencial_valorizacao >= 0) %>% 
  dplyr::arrange(desc(potencial_valorizacao))
