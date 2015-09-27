library(shiny)
library(wordcloud)
library(tm)

getDocumentTermMatrix <- function(input=NULL){

        textInput <- input
        processedText <- VectorSource(textInput)
        corpus <- Corpus(processedText)
        corpus <- tm_map(corpus,content_transformer(tolower))
        corpus <- tm_map(corpus,removePunctuation)
        corpus <- tm_map(corpus,removeWords,stopwords("SMART"))
        corpus <- tm_map(corpus,stripWhitespace)
        
        dtmObj <- DocumentTermMatrix(corpus)
        dtm <- as.matrix(dtmObj)
}

getWordCloudInput <- function(dtm){
        Frequency <- colSums(dtm)
        Text <- names(Frequency)
        df <- as.data.frame(cbind(Text,Frequency))
        df$Text<-as.character(df$Text)
        df$Frequency<-as.numeric(as.character(df$Frequency))
        rownames(df) <- NULL
        df
}

shinyServer(function(input, output) {
        val <- reactiveValues(df=NULL)
        
        observeEvent(input$sample,{
                dtm <- getDocumentTermMatrix(input$sampletext)
                df <- getWordCloudInput(dtm)
                df <- df[order(-df$Frequency,df$Text),]
                val$df <- df
                output$cloud <- renderPlot(wordcloud(val$df[['Text']],val$df[['Frequency']], 
                                                     scale=c(7,0.1), min.freq=1,
                                                     max.words=50, random.order=FALSE, 
                                                     rot.per=.15, colors=palette()))
        }) 
        
        #Grab the input text
        observeEvent(input$generate,{
                dtm <- getDocumentTermMatrix(input$textinput)
                df <- getWordCloudInput(dtm)
                df <- df[order(-df$Frequency,df$Text),]
                val$df <- df
                output$cloud <- renderPlot(wordcloud(val$df[['Text']],val$df[['Frequency']], 
                                                     scale=c(7,0.1), min.freq=1,
                                                     max.words=50, random.order=FALSE, 
                                                     rot.per=.15, colors=palette()))
        })

        # Output the word cloud
        palette <- reactive({brewer.pal(5,input$palette)})
        
        ihaveadream <- readRDS("data/ihaveadream.RDS")
        output$ihaveadream <- renderUI({tags$textarea(id="sampletext",
                                                      rows=10,style="width:100%",
                                                      ihaveadream, readonly="true")})
        
        # Output the result table
        # ---------------------------------------------------
        output$resultTable <- renderDataTable(
                val$df,
                options=list(pageLength=10,
                             lengthMenu=list(c(10,20,50,-1), c('10','20','50','All')),
                             columnDefs=list(list(targets=0,searchable=FALSE)),
                             searching = FALSE))
        
        # Render examples of palette the user can choose from
        # ---------------------------------------------------
        output$brewerSampleSeq <- renderPlot(
                                        display.brewer.all(n=5,
                                        type="seq", 
                                        select=c("Greys",
                                                 "Blues","PuRd","BuPu","YlOrRd"), 
                                        exact.n=TRUE))
        
        output$brewerSampleQual <- renderPlot(
                                        display.brewer.all(n=5,
                                        type="qual", 
                                        select=c("Dark2",
                                                 "Paired","Pastel2","Pastel1","Accent"), 
                                        exact.n=TRUE))
        
})