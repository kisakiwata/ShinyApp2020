library(DT)
library(RColorBrewer)
#detach(package:plyr)

shinyServer(function(input, output, session){
    
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
    
    output$dens <- renderPlot(
        df %>% 
            ggplot(., aes(x=Employment.Change)) +
            geom_density(se=FALSE, color="darkblue", fill="lightblue") + 
            geom_vline(aes(xintercept=mean(Employment.Change)),
                       color="red", linetype="dashed", size=1)+
            ggtitle("   Employment Change 2016 (Total)") +
            xlab("")
        )
     output$scatter <- renderPlot(
         ent.df %>% 
             dplyr::filter(., enterprise.size == 1, industry.name==input$change) %>% 
             ggplot(., aes(x = Establishment.Change, y = Employment.Change)) +
             geom_point(color='blue',size=4) +
             xlab("Change of Establishment (%)")+
             ylab("Change of Employment (%)") +
             ggtitle("2015-2016 Change by State") +
             geom_text(aes(label=state.name),
                       hjust=0.8, vjust=1.4,angle = -30, size=3)+
             theme_bw()
         
    )
     d <- reactive({
         df3 = df2 %>%
             dplyr::filter(., state.name == "United States") %>% 
             dplyr::filter(., industry=="Total") %>% 
             slice(., 1:56) %>% 
             select(., year, enterprise.size, Net.Change.Est, Net.Change.Emp) %>% 
             gather(., key="Type", value="Net.Change", Net.Change.Est, Net.Change.Emp)
         
         df3$Net.Change = as.numeric(as.character(df3$Net.Change))
         df3$enterprise.size = as.numeric(as.character(df3$enterprise.size))
     })
     
     output$time <- renderPlot(
         df3 %>% 
             dplyr::filter(., enterprise.size==input$size) %>% 
             ggplot(.,aes(x=as.factor(year),y=as.numeric(as.character(Net.Change)))) + 
             geom_bar(aes(fill=Type), stat='identity',position='dodge') + 
             theme_bw() +
             ylab("Net Change") +
             xlab("Year") +
             ggtitle("2010-2016 Net Change - Enterprise and Employment") +
             scale_fill_discrete(name = "", labels = c("Employment", "Enterprise"))
     )
    
    output$table <- DT::renderDataTable({
        datatable(map.df) %>% 
            formatStyle(input$change, background="skyblue", fontWeight='bold')
    })
    
    
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