library(DT)
library(shiny)
library(googleVis)
library(tidyverse)
library(RColorBrewer)


shinyServer(function(input, output){
    # show map using googleVis
    output$map <- renderGvis({
        gvisGeoChart(map.df, "state.name", input$change,
                     options=list(region="US", displayMode="regions", 
                                  resolution="provinces",
                                  width="auto", height="auto", 
                                  colorAxis="{colors:['blue', 'lightblue']}"
                                  #backgroundColor="grey"
                                  )
        )
    })
    
    # show histogram using googleVis
    output$hist <- renderPlot(
        df %>% 
            #group_by(., industry.name, Employment.Change) %>% 
            ggplot(., aes(x=Employment.Change)) +
            geom_density(se=FALSE, color="darkblue", fill="lightblue") + 
            geom_vline(aes(xintercept=mean(Employment.Change)),
                       color="red", linetype="dashed", size=1)+
            ggtitle("   Employment Change") +
            xlab("")
            #scale_fill_brewer(palette = "OrRd")
        )
    
    # show data using DataTable
    output$table <- DT::renderDataTable({
        datatable(map.df) %>% 
            formatStyle(input$change, background="skyblue", fontWeight='bold')
    })
    
    # show statistics using infoBox
    output$maxBox <- renderInfoBox({
        max_value <- max(map.df[,input$change])
        max_state <- 
            map.df$state.name[map.df[,input$change] == max_value]
        infoBox(max_state, max_value, icon = icon("angle-double-up"))
    })
    output$minBox <- renderInfoBox({
        min_value <- min(map.df[,input$change])
        min_state <- 
            map.df$state.name[map.df[,input$change] == min_value]
        infoBox(min_state, min_value, icon = icon("angle-double-down"))
    })
    output$avgBox <- renderInfoBox(
        infoBox(paste("Average Change"),
                round(mean(map.df[,input$change]), digits=1),
                icon = icon("calculator"), 
                fill = TRUE)
    )
})