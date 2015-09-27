library(shiny)

shinyUI(fluidPage(
        titlePanel(strong("Word Cloud Generator")),
        hr(),
        fluidRow(column(5,
                        h4("Hello and welcome ... "),
                        p("This application to help you generate word clouds
                        from blocks of text. The application uses the tm package to perform
                        a series of text mining tasks and the wordcloud package
                        to plot the word cloud. The series of text mining tasks are
                        listed below.",
                        tags$li("Convert the text to lower case"),
                        tags$li("Remove all punctuations"),
                        tags$li("Remove stop words based on the English language"),
                        tags$li("Strip all extra white spaces "),
                        tags$li("Construct a Document Term Matrix"),
                        tags$li("Count the occurance of individual words"),align="justify")),
                 column(1),
                 column(6,
                        h4("Some things to note ..."),
                        p("The application works only with the English language."),
                        p("You may try generating the word cloud using
                           the sample text provided to see how it works.
                           Alternatively, you may want to try it with your text.",align="justify"),
                        p("The input is limited to 10000 characters, which is about
                           2000 words using the English language so as to ensure that
                           the application runs smoothly.",align="justify"),
                        p("More instructions are provided in the form below."))),
        hr(),
        fluidRow(column(5,
                        tabsetPanel(
                                tabPanel("Try with Sample Text!",
                                         br(),
                                         p(em("Click on Generate Word Cloud button below to generate a word
                                          cloud using the sample text provided.")),
                                         br(),
                                         uiOutput("ihaveadream"),
                                         div(style="float:left; padding-right:10px",actionButton("sample","Generate Word Cloud")),
                                         p("Sample Text from I have a Dream by Martin Luther King Jr",
                                           style="font-size:12px; font-style:italic; color:grey")),
                                tabPanel("Try with Your Own Text!",
                                         br(),
                                         p(em("Paste your text in the text area below and 
                                               click on Generate Word Cloud button below to 
                                               generate the word cloud.")),
                                         tags$textarea(id="textinput", 
                                                       maxlength=10000,rows=10,style="width:100%",
                                                       "<Insert Text Here>"),
                                         br(),
                                         actionButton("generate", "Generate Word Cloud")
                                         )
                                )),
                 column(1),
                 column(6,
                        tabsetPanel(
                               tabPanel("Colour Selector",
                                        br(),
                                        p(em("Once the word cloud is generated,
                                             select a colour palette below and watch the word 
                                             cloud change colours. You may refer to the sequential and 
                                             qualitative colour references for the colours used in the
                                             word cloud.")),
                                        radioButtons(inputId="palette",
                                                     label=NULL,
                                                     choices=c("Sequential - YlOrRd" = "YlOrRd",
                                                               "Sequential - BuPu" = "BuPu",
                                                               "Sequential - PuRd" = "PuRd",
                                                               "Sequential - Blues" = "Blues",
                                                               "Sequential - Greys" = "Greys",
                                                               "Qualitative - Accent" = "Accent",
                                                               "Qualitative - Pastel1" = "Pastel1",
                                                               "Qualitative - Pastel2" = "Pastel2",
                                                               "Qualitative - Paired" = "Paired",
                                                               "Qualitative - Dark2" = "Dark2"))),
                               tabPanel("Seq. Colours Ref.",
                                        plotOutput("brewerSampleSeq",height = "300px")),
                               tabPanel("Qual. Colours Ref.",
                                        plotOutput("brewerSampleQual", height = "300px"))
                               )
                       )),
        hr(),
        fluidRow(column(7,
                        h4("Word Cloud Output"),
                        br(),
                        plotOutput("cloud",width=500, height=500)
                        ),
                 column(5,
                        h4("Word Count Result"),
                        p(),
                        dataTableOutput("resultTable")
                 )),
        hr()
))