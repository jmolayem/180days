library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Los Angeles Drought Sentiment This Week"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of Tweets in past 7 days:",
                  min = 1,
                  max = 50,
                  value = 30),
      radioButtons("iType", "Choose plot type:",
                   list("sentiment","emotion","cloud","time", "long term progress (IP)", "geographical analysis (IP)")),
      helpText("Accessing Twitter now. This may take a few seconds upon initial load."),
      downloadButton('downloadData','Download')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))