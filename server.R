library(DT)
library(shiny)
library(googleVis)
library(tidyverse)
library(RColorBrewer)


shinyServer(function(input, output, session){
    # show map using googleVis
    output$map <- renderGvis({
        gvisGeoChart(map.df, "state.name", input$change,
                     options=list(region="US", displayMode="regions", 
                                  resolution="provinces",
                                  width="auto", height="auto", 
                                  colorAxis="{colors:['blue', 'lightblue']}",
                                  title="2015-2016 Employment Change by State (%)"
                                  )
        )
    })
    
    # show histogram using googleVis
    output$dens <- renderPlot(
        df %>% 
            #group_by(., industry.name, Employment.Change) %>% 
            ggplot(., aes(x=Employment.Change)) +
            geom_density(se=FALSE, color="darkblue", fill="lightblue") + 
            geom_vline(aes(xintercept=mean(Employment.Change)),
                       color="red", linetype="dashed", size=1)+
            ggtitle("   Employment Change 2016 (Total)") +
            xlab("")
        )
     #output$hist <- renderPlot(
    #)
     d <- reactive({
         detach(package:plyr)
         library(tidyr)
         library(scale_colour_brewer)
         
         df3 = df2 %>%
             filter(., state.name == "United States") %>% 
             filter(., industry=="Total") %>% 
             slice(., 1:56) %>% 
             select(., year, enterprise.size, Net.Change.Est, Net.Change.Emp) %>% 
             gather(., key="Type", value="Net.Change", Net.Change.Est, Net.Change.Emp)
         
         df3$Net.Change = as.numeric(as.character(df3$Net.Change))
         df3$enterprise.size = as.numeric(as.character(df3$enterprise.size))
     })
     
     output$time <- renderPlot(
         
         df3 %>% 
             filter(., enterprise.size==input$size) %>% 
             ggplot(.,aes(x=as.factor(year),y=as.numeric(as.character(Net.Change)))) + 
             geom_bar(aes(fill=Type), stat='identity',position='dodge') + 
             theme_bw() +
             ylab("Net Change") +
             xlab("Year") +
             ggtitle("2010-2016 Net Change - Enterprise and Employment") +
             scale_fill_discrete(name = "", labels = c("Employment", "Enterprise"))
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
        infoBox(max_state, paste0(max_value,"%"), icon = icon("angle-double-up"))
    })
    output$minBox <- renderInfoBox({
        min_value <- min(map.df[,input$change])
        min_state <- 
            map.df$state.name[map.df[,input$change] == min_value]
        infoBox(min_state, paste0(min_value,"%"), icon = icon("angle-double-down"))
    })
    output$avgBox <- renderInfoBox(
        infoBox(paste("Average Change"),
                paste0(round(mean(map.df[,input$change]), digits=1),"%"),
                icon = icon("calculator"), 
                fill = TRUE)
    )
})