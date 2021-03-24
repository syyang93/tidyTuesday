library(shiny)
library(magrittr)
library(shinythemes)
library(rsconnect)
library(tidyverse)
library(rsconnect)
library(ggplot2)
library(magrittr)
library(dplyr)

# Deploy 
# rsconnect::setAccountInfo(name='syyang93',
#                           token='myToken',
#                           secret='mySecret')
# setwd('~/Documents/Work/tidyTuesday/3.16.2021/')
# deployApp(appName = 'look_games_app')

games <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-03-16/games.csv')

# Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # must specify encoding!
# Sys.setlocale("LC_ALL", "English")

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("superhero"),

    # Application title
    titlePanel("Game Popularity Over Time"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("game", div(style = "font-size:20px", "Game:"), 
                          choices = c(sort(unique(games$gamename))), selected = c("Hollow Knight"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$distPlot <- renderPlot({
        games %>% filter(gamename == input$game) %>% mutate(month_year = as.Date(paste0(year, '-', month, '-', 1), format = c("%Y-%B-%d"))) -> game_picked
        
        ggplot(game_picked, aes(month_year, avg)) + geom_line(col = 'black') + xlab('Date') + ylab('# of simultaneous players') + theme_classic() + theme(text = element_text(size = 15)) + geom_vline(xintercept = as.Date('2020-3-1'), col = 'darkgray', linetype = 'dashed') + annotate('text', x = as.Date('2020-3-1'), y = max(game_picked$avg) - sd(game_picked$avg), label = 'COVID-19 shutdown', size = 5, vjust = -0.5, angle = 90, col = 'black') 
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
