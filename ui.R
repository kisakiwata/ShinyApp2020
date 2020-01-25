library(DT)

#suppressPackageStartupMessages(library(googleVis))


shinyUI(
    dashboardPage(
        skin="blue",
    dashboardHeader(
        title = "U.S. Employment and Business Size Change",
        #title="2015-2016 Employment Change by State (%)",
        titleWidth = 1000,
        #tags$li("Kisaki Watanabe",
                #style = 'text-align: right; padding-right: 13px; padding-top:17px; font-family: Roboto, sans-serif;
                              #font-weight: bold;  font-size: 13px; font-style: italic;',
                #class='dropdown'),
        tags$li(a(href = 'https://www.linkedin.com/in/kisaki-watanabe-1349b925/',
                  img(src = 'linkedin.png',
                      title = "Kisaki's LinkedIn", 
                      height = "19px")),
                class = "dropdown"),
       tags$li(a(href = 'https://github.com/kisakiwata/ShinyApp2020.git',
                  img(src = 'github.png',
                      title = "Github Repository", 
                      height = "19px")),
                class = "dropdown")
        ),
    dashboardSidebar(
        sidebarUserPanel(
            "Kisaki Watanabe",
            image = "Me.jpg",
            subtitle = 'NYC Data Science Fellow'
        ),
        sidebarMenu(
            menuItem(text = 'Maps', icon = icon('map-pin'), tabName = 'map'), #change the icon
            menuItem(text = 'Time Series', icon = icon('chart-line'), tabName = 'time'),
            menuItem(text = 'Graphs', icon = icon('chart-bar'), tabName = 'graph'),
            menuItem(text = 'Data', icon = icon('table'), tabName = 'data'),
            menuItem(text = 'Documentation', icon = icon('chart-bar'), tabName = 'doc'))
        #selectizeInput("change",
                   #"Select Industry",
                   #choices=choice1)
    ),
    dashboardBody(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        tabItems(
            tabItem(
                tabName = "map",
                fluidPage(
                fluidRow(infoBoxOutput("maxBox"),
                         infoBoxOutput("minBox"),
                         infoBoxOutput("avgBox")),
                fluidRow(column(8, box(htmlOutput("map"), height = 600, width = 300)),
                column(4, radioButtons("change", h3("Select Industry"),
                                              choices = choice1))
                )
                )
                ),
            tabItem(tabName="time", 
                    fluidPage(
                        fluidRow(plotOutput("time"), height = 380, width = 400),
                        br(),
                        fluidRow(radioButtons("size", h4("Select Enterprise Size \n (Numer of Employees)"), choices = c("Total"=1, "1-4"=2, "5-9"=3, "10-19"=4, "20-99"=5, "100-499"=6, "<500"=7, "500+"=8)
                                              ))
                    )
            ),
            tabItem(tabName="graph", 
                    fluidPage(
                        fluidRow(box(plotOutput("dens"), height = 400, width = 400))
                        #fluidRow(box(plotOutput("hist"),height = 400, width = 400))
                    )
            ),
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("table"), width = 12))),
            tabItem(tabName = "doc", 
                    fluidPage(
                    fluidRow(
                        column(6,
                             strong("About Statistics of US Business (SUSB)"),
                             p("SUSB is an annual series that provides national and subnational data on the distribution of economic data by enterprise size and industry."), 
                             br(),
                             p("SUSB employment change or dynamic data include number of establishments
                                and corresponding employment change for initial year, births, deaths, expansions,
                                and contractions. The data are tabulated by geographic area, industry, and 
                                employment size of the enterprise. Industry classification is based on 2012 
                                North American Industry Classification System (NAICS) codes."),
                             br(),
                             a("https://www.census.gov/data/datasets/2016/econ/susb/2016-susb1.html"),
                             br(),
                             br()
                             ),
                    column(6,
                             strong("About Me"),
                             br(),
                             p("Kisaki’s skillset mainly centers around data analytics/visualization and risk management."),
                                p("She has provided services for Japanese and international clients in a variety of industries 
                                such as SNS, game, pharmaceutical, media, advertising, etc at KPMG. Before joining KPMG,
                                she served as project leader at North American headquarter of Japanese Tier 1 automotive manufacturer/supplier 
                                with responsibility for J-SOX testing of financial, corporate, and IT systems. 
                                She led and corded internal audit and risk management activities at cross-regional environment.  
                                She managed risk assessment results and their reporting, analysis, and action items at N.A. sites and 
                                worked closely with the management in the U.S. and counterpart department in Japan."), 
                            p("With the above backgrounds, she had shifted towards more to data analytics consulting in 2018-9 such as 
                                data analytics and visualization with tools like Alteryx, Tableau, and Qlikview. 
                                Her experiences cover fraud analysis and risk scenario case studies."),
                            p("Currently she is further expanding her expertise in data science that combines the programming skills 
                                in R and Python and statics/math knowledge at NYC Data Science Academy in NY, USA.")
                             )
                           )
                    )
                    )
        )
        )
        )
)
