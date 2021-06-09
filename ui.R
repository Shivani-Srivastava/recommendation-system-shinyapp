library(quanteda)
library(ggplot2)
library(magrittr)
library(text2vec)
library(shinyWidgets)




shinyUI(fluidPage(
  title = "Recommendation System",
  titlePanel(title=div(img(src="logo.png",align='right'),"Recommendation System")),
  
  # Input in sidepanel:
  sidebarPanel(
    
    conditionalPanel(condition="input.tabselected==1",
    fileInput("file", "Upload Input file")
 
    ),
    conditionalPanel(condition="input.tabselected==2",
                     checkboxInput("adj","Check if adjaceny matrix uploaded",FALSE),
                     uiOutput("user_ui"),
                     uiOutput("item_ui"),
                     uiOutput("rating_ui")
                    # uiOutput('adj_btn')
                     ),
    conditionalPanel(condition = "input.tabselected==3",
                     uiOutput("focal_list")
                     )
  ),
  
  # Main Panel:
  mainPanel( 
    tabsetPanel(type = "tabs",
                #
                tabPanel("Overview & Example Dataset",value=1,
                         
                         h4(p("Overview")),
                         p("A recommender system, or a recommendation system, is a subclass of information filtering system that seeks to predict the 'rating' or 'preference' a user would give to an item.
                           ", align = "Justify"),
                         tags$a(href="https://en.wikipedia.org/wiki/Recommender_system#:~:text=A%20recommender%20system%2C%20or%20a,primarily%20used%20in%20commercial%20applications", 
                                "-Wikipedia"),
                         hr(),
                         h4(p("How to use this App")),
                         p("", align = "justify"),
                         p("Upload data to sidebar panel and select focal user for which recommendation is require. Once you change the user, App will automatically refresh and display recommendation for respective user in different output tabs.
                           ", align = "Justify"),
                         h4(p("Input Data Format")),
                         p("Application takes either of two different type of inputs. One is Adjacency Matrix as shown below
                           ", align = "Justify"),
                         img(src = "dataset.png"),
                         p("Also, App can take long format dataset. As shown below"),
                         img(src = "long.png"),
                         hr(),
                         h4(p("Download Sample text file")),
                         
                         downloadButton('downloadData1', 'Download Sample Input file'),br(),br(),
                         p("Please note that download will not work with RStudio interface. Download will work only in web-browsers. So open this app in a web-browser and then download the example file. For opening this app in web-browser click on \"Open in Browser\" as shown below -"),
                         img(src = "example1.png")
                         #, height = 280, width = 400

                         
                )  ,
            
                
                tabPanel("Data Summary", value=2,
                         h4("Summary Report"),
                         verbatimTextOutput("dim"),
                         hr(),
                         h4("Sample Dataset"),
                         dataTableOutput("samp_data"),
                         hr(),
                         uiOutput("xyz"),
                         uiOutput("pqr"),
                         dataTableOutput("dtm_head"),
                         hr(),
                         h4("Word Frequency Table"),
                         dataTableOutput("freq_table")
                         
                         ),
                tabPanel("IBCF Recommendation",value=3,
                        h4("Item-based collaborative filtering (IBCF)"),
                        DT::dataTableOutput('ibfc_re')
                         
                ),
                tabPanel("UBCF Recommendation",value=3,
                         h4("User-based collaborative filtering (UBCF)"),
                         DT::dataTableOutput('ubfc_re')
                         
                ),
               tabPanel("Similar Users",value=3,
                        h4("Similar Users"),
                        DT::dataTableOutput("sim_usr")
               ),id = "tabselected"
                
                
    )
  )
)
)
