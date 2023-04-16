library(dplyr)
library(tidyr)
library(data.table)
library(scales)
library(markdown)
library(shiny)
library(htmlwidgets)
library(shinyWidgets)
library(RColorBrewer)
library(knitr)
#library(gganimate)

colunas <- names(Bancossh)
salarios <- Bancossh

library(tibble)
library(dplyr )

Bancossh <- Bancossh %>% 
  tibble::rownames_to_column(var = "n")

Bancossh$n <- as.numeric(Bancossh$n)

shinyUI(
  fluidPage(
    
   # theme = bslib::bs_theme(bootswatch = "minty"),
    

    
    tags$head(tags$style(
      "body { word-wrap: break-word; }"
    )),
    tags$head(
      tags$link(rel = "shortcut icon", href = "img/logo_infnet"),
      #-- biblio js ----
      tags$link(rel="stylesheet", type = "text/css",
                href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"),
      tags$link(rel="stylesheet", type = "text/css",
                href = "https://fonts.googleapis.com/css?family=Open+Sans|Source+Sans+Pro")
    ),
    #includeCSS("www/styles.css"),
    navbarPage("Análise exploratória de dados",
                 tabPanel("Análise de Reclamações",
                        p("Gráfico de linhas sob seleção de variáveis"),
                        #Painel principa com plot de salarios por linha
                        mainPanel(plotOutput("salarios_linha")),
                        
                        #Layout em flow para melhor justaposicao das opcoes
                        flowLayout(
                          #Selecao das variaveis na base salarios
                          varSelectInput("variaveis_salarios", "Variáveis Reclamações:", salarios, multiple = FALSE),
                          #Selecao de cores
                          selectInput('cor', label = 'Escolha uma cor:',
                                      choices = c("lightblue", "lightgreen", "red"), selected = "red"),
                          
                        ),
                        
                        #Definindo o range do eixo x
                        numericRangeInput(inputId = "x_lim", label = "Insira valor mínimo e máximo para eixo x:",
                                          value = c(min(salarios$n), max(salarios$n))
                        ),
                        
                        #Definindo o range do eixo y
                        numericRangeInput(inputId = "y_lim", label = "Insira valor mínimo e máximo para eixo y:",
                                          value = c(min(salarios$n), max(salarios$n))
                        )
                        )),
                        
                        
                        navbarPage("Análise exploratória de dados",
                            tabPanel("Gráfico de linhas para seleção de 2 variáveis",                                 p("Gráfico de 2 linhas sob seleção de variáveis"),
                                 
                            
                               
                                   sidebarLayout(
                                     sidebarPanel(
                                       flowLayout(
                                       selectInput(
                                         "varX",
                                         label = "Variável eixo X",
                                         choices = colunas
                                       ),
                                       selectInput(
                                         "varY",
                                         label = "Variável eixo Y",
                                         choices = colunas,
                                         selected = colunas[6]
                                       )
                                     )),
                                     
                                     sidebarPanel(
                                       selectInput('cor', label = 'Escolha uma cor:', 
                                                   choices = c("lightblue", "lightgreen", "red"), selected = "red")
                                       
                                     )),
                                   
                                   
                                   mainPanel(
                                     plotOutput("grafico")
                                   )
                        
                        
                        
                        
                        
               )))
       
               )
    
  
