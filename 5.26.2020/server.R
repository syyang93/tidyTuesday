library(shiny)
library(magrittr)
library(shinythemes)
library(rsconnect)
library(tidyverse)
library(rsconnect)

Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # must specify encoding!
Sys.setlocale("LC_ALL", "English")

cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/cocktails.csv')
boston_cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/boston_cocktails.csv')
cocktails = dplyr::select(cocktails, drink, drink_thumb)
cocktails = unique(cocktails)
w.img = merge(boston_cocktails, cocktails, by.x  = 'name', by.y = 'drink', all.x = TRUE)
w.img %>% 
  group_by(name) %>% 
  mutate(all.ingredients = paste0(ingredient, collapse = ", ")) %>% dplyr::select(name, category, drink_thumb, all.ingredients) %>% unique -> ingr.one
ingr.one = unique(ingr.one)

# setwd('~/Documents/Making Things/Tidy.Tuesday/Cocktails/')
function(input, output) {
  drink.picked <- reactive ({
    # print(req)
    # ingr.one = ingr.one[req,]
    if(length(input$requests)!=0){
      index = grep(input$requests, tolower(ingr.one$all.ingredients))
      if(input$requests == paste0(c('carbonate', 'soda', 'cola', 'sparkling'), collapse = '|')){
        index = union(index, grep('fizz', tolower(ingr.one$name)))
      }
      ingr.one = ingr.one[index,]
    }
    if(input$category != "Any"){ingr.one %>% filter(category == input$category) -> poss.drinks} else{poss.drinks = ingr.one}
    if(input$pics == TRUE){
      poss.drinks = poss.drinks[-which(is.na(poss.drinks$drink_thumb)),]
    }
    if(length(input$norequests) != 0){
      no.string = paste0(input$norequests, collapse = '|')
      bad.index = grep(no.string, tolower(poss.drinks$all.ingredients))
      if(length(bad.index!= 0)){poss.drinks = poss.drinks[-bad.index,]}
      if(paste0(c('carbonate', 'soda', 'cola', 'sparkling'), collapse = '|') %in% input$norequests){
        poss.drinks = poss.drinks[-grep("Fizz", poss.drinks$name),]
      }
    }
    set.seed(input$button)
    drink.picked = poss.drinks[sample(nrow(poss.drinks), 1),]
    if(nrow(drink.picked) != 0){drink.picked$name} else{'Too many restrictions, no drink selected!'}
  })
  output$drink <- renderText({
    paste0('', drink.picked(),'')
  })
  
  output$picture<-renderText({
    # subset drink picked
    if(drink.picked() == 'Too many restrictions, no drink selected!'){c('<img src="https://www.freepngimg.com/download/icon/1000074-sad-face-emoji-free-photo-icon.png", height="30%", width="30%">')} else{
      drink = subset(ingr.one, name == drink.picked())
      if(!is.na(drink$drink_thumb[1])){
      c('<img src="', drink$drink_thumb[1], '", height="50%", width="50%">')} else{
        c('<img src="https://upload.wikimedia.org/wikipedia/en/6/60/No_Picture.jpg", height="30%", width="30%">')
      }
    }
  })
}
