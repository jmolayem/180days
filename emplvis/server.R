library(shiny)
library(ggplot2)
library(lattice)
library(doBy)
library(base)
library(reshape2)
library(dplyr)
library(plyr)
library(data.table)
library(forecast)
library(wordcloud)

cd<-read.csv("./db/real.csv")

analysis<-read.csv("./db/analysis.csv")
analysis$Period<-as.Date(analysis$Period,format="%m/%d/%Y")
zreal<-read.csv("./db/zreal.csv")
zempl<-read.csv("./db/zempl.csv")
cd$Period<-as.Date(cd$Period,format="%m/%d/%Y")
cd$Task <- cd$Task[,drop = TRUE]
cd$Project<-as.factor(cd$Project)
cd$Empl<-as.character(cd$Empl)

# Define shiny server
shinyServer(function(input, output) {
  pdata<-reactive({
    subset(cd, Project==input$proj)
  })
  zdata<-reactive({
    summaryBy(Hours ~ Period, data = pdata(), FUN=sum )
  })
  ldata<-reactive({
    pdata()[order(as.Date(pdata()$Period,format="%m/%d/%Y")),]
  })
  wdata<-reactive({
    count(pdata(),Task)
  })
  
  l2data<-reactive({
    idata()[order(as.Date(idata()$Period,format="%d/%m/%Y")),]
  })

  plotType <- reactive({
    switch(input$pType,
           Total = ggplot(ldata(),aes(x=Period,y=cumsum(Hours)))+geom_line(),
           Trend = ggplot(zdata(),aes(x=Period,y=Hours.sum))+ geom_line()+stat_smooth(),
           Forecasts = plot(forecast(nnetar(ts(zdata()$Hours.sum)),h=input$pay),main="Neural Net Project Prediction",xlab="Number of Pay Periods",ylab="Hours"),
           ID = ggplot(head(aggregate(Hours~Empl,data=pdata(),sum)[order(aggregate(Hours~Empl,data=pdata(),sum)$Hours,decreasing = TRUE), ], input$taskno), aes(x=Empl,y=Hours))+geom_bar(stat="identity",aes(fill=factor(Empl))),
           Wordcloud = wordcloud(words=wdata()$Task,freq=wdata()$n,colors=brewer.pal(8, "Dark2"),min.freq=input$storm),
           Effort = densityplot(pdata()$Hours,lwd=3,xlab="Hours Committed (Biweekly)",main="Commitment Density Plot"),
           Experience= densityplot(pdata()$Amount/pdata()$Hours,xlab="Wage ($)",main="Experience Density Plot",lwd=3),
           Tasks = ggplot(head(aggregate(Hours~Task,data=pdata(),sum)[order(aggregate(Hours~Task,data=pdata(),sum)$Hours,decreasing = TRUE), ], input$taskno), aes(x=Task,y=Hours))+geom_bar(stat="identity",aes(fill=factor(Task))),
           Calendar = ggplot(head(aggregate(Hours~Period+Task,data=pdata(),sum)[order(aggregate(Hours~Period+Period,data=pdata(),sum)$Hours,decreasing = TRUE), ], input$taskno),aes(x=Period,y=Hours))+ geom_bar(stat="identity",aes(fill=factor(Task))),
           Task_by_Date = ggplot(ddply(pdata(), .(Task), transform, cy = cumsum(Hours)), aes(x=Period, y=cy, colour=Task, group=Task)) + geom_line()+geom_text(aes(label=Task,size=Hours))
    )
  })
  dplot <- reactive({
    switch(input$dtype,
           Total= ggplot(analysis,aes(x=Period,y=summ))+ geom_line()+stat_smooth(),
           Forecast = plot(forecast(nnetar(ts(analysis$summ)),h=input$pay2),main="Neural Net Project Prediction",xlab="Number of Pay Periods",ylab="Hours"),
           Trending_Projects = wordcloud(words=zreal$Project,freq=zreal$sum3,colors=brewer.pal(8, "Dark2"),min.freq=input$freqq),
           Trending_Engineers = wordcloud(words=zempl$Empl,freq=zempl$sum2,colors=brewer.pal(8, "Dark2"),min.freq=input$freqq)
    )
  })

  output$testPlot <- renderPlot({
    print(plotType())
  })
  output$indplot <- renderPlot({ 
    print(iplot())
  })
  output$summary <- renderPlot({
    print(dplot())
  })

})