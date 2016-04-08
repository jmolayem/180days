library(shiny)

cd<-read.csv("./db/real.csv")
cd$Project<-as.factor(cd$Project)
cd$Empl<-as.character(cd$Empl)
zreal<-read.csv("./db/zreal.csv")
zempl<-read.csv("./db/zempl.csv")
ulist=levels(cd$Project)
names(ulist) = ulist

shinyUI(navbarPage("Project!",
                     tabPanel("Project",
                              sidebarLayout(
                                sidebarPanel(
                                  selectizeInput("proj", "Project:",ulist),
                                  sliderInput("pay",
                                              "Input Forecast",
                                              min = 1,
                                              max = 20,
                                              value=5),
                                  sliderInput("storm",
                                              "Input Word Frequency:",
                                              min = 1,
                                              max = 20,
                                              value=5),
                                  sliderInput("taskno",
                                              "Input Desired Range",
                                              min = 1,
                                              max = 100,
                                              value=5),
                                  radioButtons("pType", "Choose plot type:",
                                               list("Total", "Trend","Forecasts", "ID","Wordcloud","Effort","Experience","Tasks","Calendar","Task_by_Date"))

                                ),
                                mainPanel(
                                  plotOutput("testPlot")
                                )
                              )
                     ),
                   tabPanel("Unitwide",
                            sidebarLayout(
                              sidebarPanel(
                                sliderInput("freqq",
                                            "Trending in Past Month:",
                                            min = 1,
                                            max = 150,
                                            value=150),
                                sliderInput("pay2",
                                            "Prediction for n^th Pay Period:",
                                            min = 1,
                                            max = 75,
                                            value=5),
                                radioButtons("dtype", "Choose plot type:",
                                             list("Trending_Engineers","Trending_Project","Total","Forecasts"))


                              ),
                              mainPanel(
                                plotOutput("summary")
                              )
                            )
                   ),
                    tabPanel("Team",
                            verbatimTextOutput("test")
                   ),
                   tabPanel("In Progress",
                            sidebarLayout(
                              sidebarPanel(
                                selectizeInput("proj2", "Project:",ulist),
                                radioButtons("pType2", "Choose plot type:",
                                             list("Sankey","machine"))
                              ),
                              mainPanel(
                                plotOutput("advanced")
                              )
                            )
                   )
  ))