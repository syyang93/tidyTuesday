library(shiny)
library(magrittr)
library(shinythemes)
library(tidyverse)

fluidPage(theme = shinytheme("superhero"),
          tags$style(type='text/css', ".selectize-input { font-size: 14; line-height: 14px;} .selectize-dropdown { font-size: 14; line-height: 1.5; }"),
          
          # Application title
          titlePanel("What kind of cocktail would you like to drink today?"),
          # Sidebar 
          sidebarLayout(
            sidebarPanel(
              selectInput("category", div(style = "font-size:20px", "Cocktail Category:"), 
                          choices = c("Any",
                                      "Cocktail Classics", 
                                      "Cordials and Liqueurs", 
                                      "Whiskies",
                                      "Brandy",
                                      "Vodka",
                                      "Rum - Daiquiris",
                                      "Tequila",
                                      "Gin"),
              ),
              checkboxInput('pics', div(style = "font-size:15px", "Only show me cocktails with pictures"), value = TRUE),
              radioButtons("requests", div(style = "font-size:20px", "Request:"), 
                           choices = c("Fruity" = paste0(c("orange", "fruit", "berries", "pear", "mango", "coconut", "cherry", "grape", "apple", "apricot"), collapse = '|'),  
                                       "Bitters" = "bitters",
                                       "Egg" = "egg",
                                       "Chocolate" = paste0(c("choco", "cacao"), collapse = '|'),
                                       "Spicy" = paste0(c("jala", "red pepper"), collapse = '|'),
                                       "Carbonated" = paste0(c('carbonate', 'soda', 'cola', 'sparkling'), collapse = '|'),
                                       "Lactose" = paste0(c('whole milk', 'cream'), collapse = '|') 
                           ),
                           
                           selected = c("Fruity"),
                           inline = FALSE
              ),
              
              checkboxGroupInput("norequests", div(style = "font-size:20px", "Things to avoid:"), 
                                 choices = c("Fruity" = paste0(c("orange", "fruit", "berries", "pear", "lemon", "lime", "mango", "coconut", "cherry", "grape", "apple", "apricot"), collapse = '|'),  
                                             "Bitters" = "bitters",
                                             "Egg" = "egg",
                                             "Chocolate" = paste0(c("choco", "cacao"), collapse = '|'),
                                             "Spicy" = paste0(c("jala", "pepper"), collapse = '|'),
                                             "Carbonated" = paste0(c('carbonate', 'soda', 'cola', 'sparkling'), collapse = '|'),
                                             "Lactose" = paste0(c('whole milk', 'cream'), collapse = '|') 
                                 ),
                                 
                                 selected = c(""),
                                 inline = FALSE
              )
            ),
            # Show the drink and picture
            mainPanel(
              h3(textOutput("drink")),
              htmlOutput("picture"),
              actionButton("button", "Give me another!")
            )
          )
)
