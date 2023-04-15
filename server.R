library(dplyr)
library(tidyr)
library(data.table)
library(scales)
library(markdown)
library(shiny)
library(zoo)
library(htmlwidgets)
library(shinyWidgets)
library(RColorBrewer)
library(knitr)
library(ggplot2)
#library(gganimate)


shinyServer(function(input, output){
  
  
  ######Painel de Reclamações
  
  #Criando um evento reativo que gera um plot quando uma das ações relacionadas 
  #ao gráfico de linhas muda, sendo elas, eixos, cores, e variáveis
  plot_salarios_reativo <- eventReactive(c(input$variaveis_salarios, input$cor, input$x_lim, input$y_lim),{
    
    #Plotando o gráfico com as definições do eixo x, de cores, etc.
    ggplot(data = salarios, aes_string(x = "n", y = input$variaveis_salarios)) +
      geom_line(color = input$cor) + ggplot2::xlim(input$x_lim) + ggplot2::ylim(input$y_lim) + theme_classic()
  })
  
  #Atualizando o range do y quando uma variável é trocada
  update_ylim <- eventReactive(c(input$variaveis_salarios),{
    if(length(input$variaveis_salarios) == 0) return(numericRangeInput(inputId = "y_lim", label = "Insira valor mínimo e máximo para eixo y:", value = c(min(salarios$n), max(salarios$n))))
    updateNumericRangeInput(inputId = "y_lim", value = c(min(salarios[,input$variaveis_salarios], na.rm = T), max(salarios[,input$variaveis_salarios], na.rm = T))) 
  })
  
  #Renderizando o plot construído iterativamente 
  output$salarios_linha <- renderPlot({
    #Controlando para o caso de não selecionar nenhuma variável, ou de a variável não ser numérica
    #De modo a não introduzir limites ao eixo y, para uma variável que não é numérica
    if ((length(input$variaveis_salarios) == 0) | (!is.numeric(unlist(salarios[,input$variaveis_salarios][1]))))
    {
      if((!is.numeric(unlist(salarios[,input$variaveis_salarios][1]))) & (length(input$variaveis_salarios) != 0)) return(ggplot(salarios, aes_string(x="n", y = input$variaveis_salarios)) + geom_line() + geom_line(color = input$cor)  + theme_classic())
      else return(ggplot(salarios, aes(x=n, y = n)) + geom_line() + geom_line(color = input$cor))
    }
    
    #Atualizando o eixo y
    update_ylim()
    #Plotando o gráfico de linhas reativamente
    plot_salarios_reativo()
  })
  
  output$grafico <- renderPlot({
    ggplot(Bancossh, aes(x = .data[[input$varX]], y = .data[[input$varY]]),) +
      geom_line(color = input$cor) 
    
  })
 
  
}
)
