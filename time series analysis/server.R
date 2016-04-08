library(shiny)
library(ggplot2)
library(data.table)
library(forecast)
library(TED)
library(ggfortify)
library(TimeProjection)
library(AnomalyDetection)

remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
  H <- 0.5 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}
#Shiny Max Request = 9 MB
options(shiny.maxRequestSize = 9*1024^2)

# Define shiny server
shinyServer(function(input, output) {
  #This function is repsonsible for loading in the selected file
  data<-reactive({
    file1<-input$file
    if(is.null(file1)){return()}
    read.table(file=file1$datapath,sep=input$sep,header=input$header,stringsAsFactors=input$stringAsFactors)
  })
  eyeType <- reactive({
    switch(input$iType,
           Moving_Average_Smooth = plot(ma(data()[,3],order=input$smooth),main="Moving Average Smooth",xlab="Time",col="blue"),
           Autocorrelation = autoplot(acf(data()[,3],plot=FALSE)),
           Histogram=ggplot(data(),aes_string(x=names(data())[3]))+geom_histogram(aes(fill = ..count..),binwidth=input$bin) +
             scale_fill_gradient("Count", low = "green", high = "red")    )
  })
  zType <- reactive({
    switch(input$zType,
           Heatmap=plotCalendarHeatmap(as.Date(data()[,1],"%m/%d/%y"),data()[,3]),
           Density = ggplot(cbind(data(),projectDate(as.Date(data()[,1],"%m/%d/%y"), size = c("narrow", "wide"),
                                                     holidays = holidayNYSE(year = unique(year(as.Date(data()[,1],"%m/%d/%y")))),
                                                     as.numeric = F, drop = T)), aes_string(names(cbind(data(),projectDate(as.Date(data()[,1],"%m/%d/%y"), size = c("narrow", "wide"),
                                                                                                                           holidays = holidayNYSE(year = unique(year(as.Date(data()[,1],"%m/%d/%y")))),
                                                                                                                           as.numeric = F, drop = T))[3]), colour = names(cbind(data(),projectDate(as.Date(data()[,1],"%m/%d/%y"), size = c("narrow", "wide"),
                                                                                                                                                                                                   holidays = holidayNYSE(year = unique(year(as.Date(data()[,1],"%m/%d/%y")))),
                                                                                                                                                                                                   as.numeric = F, drop = T))[10])))+geom_density(alpha=0.4),
           Hour_Density = ggplot(cbind(data(),projectDate(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S"), size = c("narrow", "wide"),holidays = holidayNYSE(year = unique(year(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S")))),as.numeric = F, drop = T)), aes_string(names(cbind(data(),projectDate(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S"), size = c("narrow", "wide"),holidays = holidayNYSE(year = unique(year(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S")))),as.numeric = F, drop = T))[3]), colour = names(cbind(data(),projectDate(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S"), size = c("narrow", "wide"),holidays = holidayNYSE(year = unique(year(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S")))),as.numeric = F, drop = T))[10])))+geom_density(),
           Day_Hour_Plot = ggplot(cbind(data(),projectDate(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S"), size = c("narrow", "wide"),holidays = holidayNYSE(year = unique(year(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S")))),as.numeric = F, drop = T)), aes_string(names(cbind(data(),projectDate(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S"), size = c("narrow", "wide"),holidays = holidayNYSE(year = unique(year(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S")))),as.numeric = F, drop = T))[12]), fill= names(cbind(data(),projectDate(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S"), size = c("narrow", "wide"),holidays = holidayNYSE(year = unique(year(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S")))),as.numeric = F, drop = T))[10]))) + geom_bar(),
           Hour_Day_Plot = ggplot(cbind(data(),projectDate(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S"), size = c("narrow", "wide"),holidays = holidayNYSE(year = unique(year(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S")))),as.numeric = F, drop = T)), aes_string(names(cbind(data(),projectDate(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S"), size = c("narrow", "wide"),holidays = holidayNYSE(year = unique(year(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S")))),as.numeric = F, drop = T))[10]), fill= names(cbind(data(),projectDate(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S"), size = c("narrow", "wide"),holidays = holidayNYSE(year = unique(year(strptime(cbind(data(),paste(data()[,1],data()[,2]))[,4],"%m/%d/%y %H:%M:%S")))),as.numeric = F, drop = T))[12]))) + geom_bar())
  })
  pdata<-reactive({
    subset(data(),dates==input$wday)
  })
  plotType <- reactive({
    switch(input$pType,
           Anomaly= AnomalyDetectionVec(pdata()[,3], max_anoms=input$anom,period=input$per, direction='both',xlabel="Constant Interval",ylabel="Flow (GPH)", plot=TRUE),
           Event_Plot = plotevents(eventDetection(pdata()[,3],38,'red',parallel=FALSE,0.05, 'real'))
    )
  })
  # Generate a summary of the Anomalies
  output$summary <- renderPrint({
    print(summary(na.exclude(remove_outliers(as.numeric(plotType()[[1]][2][,1])))))
  })
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
  })
  output$iPlot <- renderPlot({
    print(eyeType())
  })
  output$testPlot <- renderPlot({
    print(plotType())
  })
  output$zPlot <- renderPlot({
    print(zType())
  })
})