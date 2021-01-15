library(quanteda)
library(ggplot2)
library(magrittr)
library(text2vec)










shinyUI(fluidPage(
  
  titlePanel(title=div(img(src="logo.png",align='right'),"Recommendation System")),
  
  # Input in sidepanel:
  sidebarPanel(
    
    fileInput("file", "Upload Input file"),
    uiOutput("focal_list"),
  ),
  
  # Main Panel:
  mainPanel( 
    tabsetPanel(type = "tabs",
                #
                tabPanel("Overview",h4(p("How to use this App")),
                         
                         p("", align = "justify"),
                         p("If you wish to change the input, modify the input in left side-bar panel and click on Apply changes. Accordingly results in other tab will be refreshed
                           ", align = "Justify"),
                         
                         #, height = 280, width = 400

                         
                )  ,
               tabPanel("Example Dataset",
                         h4(p("Download Sample text file")),
                         downloadButton('downloadData1', 'Download Sample Input file'),br(),br(),
                         p("Please note that download will not work with RStudio interface. Download will work only in web-browsers. So open this app in a web-browser and then download the example file. For opening this app in web-browser click on \"Open in Browser\" as shown below -"),
                         img(src = "example1.png")
                         
                         ),
                
                tabPanel("DTM Descriptive", 
                         h4("Summary Report"),
                         verbatimTextOutput("dim"),
                         br(),
                         h4("Sample Dataset"),
                         dataTableOutput("dtm_head"),
                         br(),
                         h4("Word Frequency Table"),
                         dataTableOutput("freq_table")
                         
                         ),
                tabPanel("IBFC Recommendation",
                        h4("IBFC Recommendation"),
                        DT::dataTableOutput('ibfc_re')
                         
                ),
                tabPanel("UBFC Recommendation",
                         h4("UBFC Recommendation"),
                         DT::dataTableOutput('ubfc_re')
                         
                )
                
                
                
                
    )
  )
)
)
