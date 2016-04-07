library(shiny)
library(twitteR)
library(httr)
library(RCurl)
library(RJSONIO)
library(stringr)
library(ROAuth)
library(pacman)
library(sentiment)
library(ggplot2)
library(plyr)
library(wordcloud)
library(ggvis)
library(reshape)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  api_key <- "1GpBxBzMerWKAPN2QM66g5Qsr"
  api_secret <- "VbnX3DDwaIlD9T8Ffr5yjbtrnZ55dWj85PjYz9GnaMO5mSIKqT"
  token <- "4890894748-Bt4idFao5qeUhQeUWDjTvA616SUJI6mYTdsloci"
  token_secret <- "rQIXvI9HUf0AZMlkiSN6g42FptVitqwzXzLcdo9sGnyQK"
  
      # connect to Twitter
      origop <- options("httr_oauth_cache")
      options(httr_oauth_cache=TRUE)
      setup_twitter_oauth(api_key, api_secret, token, token_secret)
      options(httr_oauth_cache=origop)
      
  tweets <- searchTwitter("wifi", n=3000, lang="en",geocode='34.04993,-118.24084,50mi', since="2016-02-20")
  some_txt = sapply(tweets, function(x) x$getText())
  some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
  some_txt = gsub("@\\w+", "", some_txt)
  some_txt = gsub("[[:punct:]]", "", some_txt)
  some_txt = gsub("[[:digit:]]", "", some_txt)
  some_txt = gsub("http\\w+", "", some_txt)
  some_txt = gsub("[ \t]{2,}", "", some_txt)
  some_txt = gsub("^\\s+|\\s+$", "", some_txt)
  
  # define "tolower error handling" function
  try.error = function(x)
  {
    # create missing value
    y = NA
    # tryCatch error
    try_error = tryCatch(tolower(x), error=function(e) e)
    # if not an error
    if (!inherits(try_error, "error"))
      y = tolower(x)
    # result
    return(y)
  }
  # lower case using try.error with sapply
  some_txt = sapply(some_txt, try.error)
  
  # remove NAs in some_txt
  some_txt = some_txt[!is.na(some_txt)]
  names(some_txt) = NULL
  class_emo = classify_emotion(some_txt, algorithm="bayes", prior=1.0)
  emotion = class_emo[,7]
  emotion[is.na(emotion)] = "unknown"
  class_pol = classify_polarity(some_txt, algorithm="bayes")
  polarity = class_pol[,4]
  sent_df = data.frame(text=some_txt, emotion=emotion, polarity=polarity, stringsAsFactors=FALSE)
  sent_df = within(sent_df,emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))
  prep <- data.frame(sent_df)
  wifi <- twListToDF(tweets)
  s <- merge(prep, wifi, by = 0, all=TRUE)
  s$created <- as.Date(as.POSIXct(s$created, format = "%m/%d/%Y", tz="UTC"))
  s_ready<-s_ready<-data.frame(s$emotion,s$polarity,s$created,s$Row.names)
  
  #x    <- wifi[, 3]  # Old Faithful Geyser data
  #bins <- seq(min(x), max(x), length.out = input$bins + 1)
  
  chartswitcher <- reactive({
    switch(input$iType,
           #histogramm=hist(x, breaks = bins, col = 'darkgray', border = 'white'),
           sentiment = ggplot(sent_df, aes(x=polarity)) + geom_bar(aes(y=..count.., fill=polarity)) + scale_fill_brewer(palette="RdGy") + labs(x="polarity categories", y="number of tweets") + ggtitle("Sentiment Analysis of Tweets about LA WiFi\n(classification by sentiment)") + theme(plot.title = element_text(size=12, face="bold")),
           emotion = ggplot(sent_df, aes(x=emotion)) + geom_bar(aes(y=..count.., fill=emotion)) + scale_fill_brewer(palette="Dark2") + labs(x="emotion categories", y="number of tweets") + ggtitle("Sentiment Analysis of Tweets about LA WiFi\n(classification by emotion)") + theme(plot.title = element_text(size=12, face="bold")),
           cloud = comparison.cloud(tdm, colors = brewer.pal(nemo, "Dark2"), scale = c(3,.5), random.order = FALSE, title.size = 1.5),
           time = ggplot(s_ready, aes(s.created, s.polarity)) + geom_line() + xlab("") + ylab("Daily Views")
           )
  })
  
  #output$downloadData <- downloadHandler(
    #filename = function() { paste(wifi, '.csv', sep='') },
    #content = function(file) {
     # write.csv(wifi, file)
   # }
  #)
  
  emos = levels(factor(sent_df$emotion))
  nemo = length(emos)
  emo.docs = rep("", nemo)
  for (i in 1:nemo)
  {
    tmp = some_txt[emotion == emos[i]]
    emo.docs[i] = paste(tmp, collapse=" ")
  }
  
  # remove stopwords
  emo.docs = removeWords(emo.docs, stopwords("english"))
  # create corpus
  corpus = Corpus(VectorSource(emo.docs))
  tdm = TermDocumentMatrix(corpus)
  tdm = as.matrix(tdm)
  colnames(tdm) = emos
  output$distPlot <- renderPlot({
    print(chartswitcher())
  })
})