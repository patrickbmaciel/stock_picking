#' @name read_data
#' @description importa dados de fiis e ações brasileiras do site fundamentus
#' @param url link do site com base de dados

read_data <- function(url) {
  
  # 1) Lendo o HTML da página
  html_content <- rvest::read_html(url)
  
  # 2) Extraindo tabelas HTML
  data <- 
    html_content %>% 
    rvest::html_table(header = TRUE)
  
  # 3) Convertendo o conteúdo HTML em texto
  html_text <- as.character(html_content)
  
  # 4) Lendo a tabela HTML
  data <- XML::readHTMLTable(html_text, header = TRUE)
  
  # 5) Selecionndo a tabela resultante do processo de extração
  if (grepl("fii", url)) { 
    
    data <- data[["tabelaResultado"]]
    
    } else {
      
      data <- data[["resultado"]]
      
    }
  
  # 6) Retornando base
  return(data)
  
}