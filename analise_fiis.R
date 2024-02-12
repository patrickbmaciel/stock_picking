# 0) Configurações iniciais -----------------------------------------------

# 0.1) Limpando R
rm(list = ls())
cat("\014")

# 0.2) Importando funções
purrr::map(paste0("functions/", list.files("functions/", pattern = ".R$")), source)

# 0.3) Importando base de dados
fiis <- read_data(url = "https://www.fundamentus.com.br/fii_resultado.php")

# 0.4) Tratando base de dados
fiis_rename <- rename_data(base = fiis)

# 0.5) Selecionando colunas
fiis_select <- 
  fiis_rename %>% 
  dplyr::select(
    # Variáveis principais
    fundo = papel, preco = "cotação", ll_yield = ffoyield, div_yield = dividendyield,
    # Indicadores de valuation
    pvp = "p/vp",
    # Variáveis informativas
    vacancia_media = vacânciamédia, qtd_imoveis = qtddeimóveis, valor_mercado = valordemercado, segmento
    )

# 0.6) Tratando dados
fiis_convert <- 
  convert_data(base = fiis_select) %>% 
  dplyr::filter(div_yield >= 0)

# 1) Análise de indicadores -----------------------------------------------

# Indicadores:
# Lucro Líquido Yield: representa a relação entre o lucro líquido anual distribuído 
# pelo fundo e o valor da cota do fundo.
# Dividendo Yield: indica a relação entre os dividendos distribuídos pelo fundo e
# o valor da cota.
# Vacância média: indica a porcentagem média de unidades não ocupadas.
# PVP: mostra a relação entre o preço atual da cota e o valor patrimonial por 
# cota do fundo.

# Segmentos
unique(fiis_filter$segmento)

# 1.1) Filtrando fiis: abordagem leve
# fiis_filter <- filter_indicators(fiis_convert,
#                                  ll_yield_min = 0,
#                                  div_yield_min = 6,
#                                  vacancia_media_max = 20,
#                                  pvp_max = 2)

# 1.1) Filtrando fiis: abordagem moderada
fiis_filter <- filter_indicators(fiis_convert,
                                 ll_yield_min = 4,
                                 div_yield_min = 8,
                                 vacancia_media_max = 10,
                                 pvp_max = 1.3)

# 1.1) Filtrando fiis: abordagem rígida
fiis_filter <- filter_indicators(fiis_convert,
                                 ll_yield_min = 8,
                                 div_yield_min = 12,
                                 vacancia_media_max = 5,
                                 pvp_max = 1.1)

# 2) Importando carteira --------------------------------------------------

# 2.1) Definindo ações na carteira
carteira <- c("HGLG11", "BTLG11", "XPLG11")

# 3.2) Filtrando base de dados
fiis_carteira <- 
  fiis_convert %>% 
  dplyr::filter(fundo %in% carteira)

# 2.1) Encontrando preços justos
carteira_preco <- gera_precos(base = acoes_carteira,
                              liq_corrente_aceitavel = 1,
                              div_desejado = 0.12)
