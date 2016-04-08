library(shiny)

flow<-read.csv("./db/anamts.csv")
flow$dates<-as.factor(flow$dates)
ulist=levels(flow$dates)
names(ulist) = ulist
shinyUI(navbarPage("Univariate Time Series Toolbox",
                   tabPanel("Data Input",
                            sidebarPanel(
                              fileInput('file', 'Choose CSV File'),
                              helpText("Default max file size is 9MB"),
                              tags$hr(),
                              h5(helpText("Select the read.table parameters below")),
                              checkboxInput(inputId='header',label='Header',value=FALSE),
                              checkboxInput(inputId='stringAsFactors',"stringAsFactors", FALSE),
                              br(),
                              radioButtons(inputId = 'sep',label='Separator',choices=c(Comma=',',Semicolon=';',Tab='\t',Space=''),selected=',')
                            ),
                            mainPanel(
                              uiOutput('tb')
                            )
                   ),
                   tabPanel("Explore Your Data",
                            sidebarLayout(
                              sidebarPanel(
                                helpText("Adjust the sliders to better understand your selection"),
                                sliderInput("smooth",
                                            "The Smoother",
                                            min=1,
                                            max=400,
                                            value=100),
                                sliderInput("bin",
                                            "Histogram Binwidth",
                                            min=1,
                                            max=100,
                                            value=10),
                                radioButtons("iType", "Choose plot type:",
                                             list("Moving_Average_Smooth","Autocorrelation","Histogram")),
                                helpText("Note: A constant ACF plot indicates a non-stationary time series. Oscilations indicate seasonality")),
                              mainPanel(
                                h4("Time Series Exploration"),
                                plotOutput("iPlot")))),
                   tabPanel("Anomaly",
                            sidebarLayout(
                              sidebarPanel(
                                selectizeInput("wday", "Project:",ulist),
                                helpText("Adjust your anomaly threshold and period to fit your day's events"),
                                sliderInput("anom",
                                            "Anomaly Threshold",
                                            min = 0.02,
                                            max = 0.4,
                                            value=0.02),
                                sliderInput("per",
                                            "Period",
                                            min = 5,
                                            max = 100,
                                            value=10),
                                radioButtons("pType", "Choose plot type:",
                                             list("Anomaly","Event_Plot")),
                                helpText("Note: Summary shows +/- 0.1 of the Interquartile Range of the anomaly values. This is to remove initial and final peaks that may occur in each event")
                              ),
                              mainPanel(
                                h4("Event Recognition and Evaluation"),
                                plotOutput("testPlot"),
                                h4("Summary"),
                                verbatimTextOutput("summary")
                              )
                            )
                   ),
                   tabPanel("Day by Day",
                            sidebarLayout(
                              sidebarPanel(
                                helpText("Actions below will disaggregate dates and times"),
                                radioButtons("zType", "Choose plot type:",
                                             list("Heatmap","Day_Density","Hour_Density","Day_Hour_Plot","Hour_Day_Plot")),
                                helpText("Note: These plots require several backend calculations. Wait may take longer.")),
                              mainPanel(
                                h4("Time Series Exploration"),
                                plotOutput("zPlot"))))
))