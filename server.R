options(shiny.maxRequestSize=15*1024^2)

shinyServer(function(input, output,session) {

#-------Data Upload---------
dataset1 <- reactive({
    if (is.null(input$file)) {return(NULL)}
    else {
      Document = read.csv(input$file$datapath,header = TRUE)
      return(Document)
      }
  })


output$pqr <- renderUI({
    if(input$adj){
      return(NULL)
    }else{
      verbatimTextOutput("dtm_sz")
    }
  })

output$dtm_sz <- renderText({
  size <- dim(dataset())
  paste0("Adjaceny Matrix has ",size[1]," (rows) "," X ",size[2]," (columns)")
})  
  

output$xyz <- renderUI({
  if(input$adj){
    return(NULL)
  }else{
    h4("Sample Adjaceny")
  }
})
output$samp_data <- renderDataTable({
  req(input$file)
  head(dataset1(),10)
})

# output$adj_btn <- renderUI({
#   if(input$adj){
#     return(NULL)
#   }else{
#     actionButton("cr_adj","Create Adjacency Matrix")
#   }
# })

dataset <- eventReactive(input$cr_adj,{
  req(input$file)
  if(!input$adj){
    df = dataset1()  # comes from fileInput in UI
    user_id = df[,input$uid]  # from UI, variable selection
    item_id = df[,input$iid]  # from UI, variable selection
  if (input$rat_id=="NA") {
     rating = rep(1, length(user_id))
  }else{
    rating = df[,input$rat_id] # from UI. Either rating colm exists or is NA
  }
    
    df0 = data.frame(user_id, item_id, rating)
    df_dups <- df0[c("user_id", "item_id")]
    df0 <- df0[!duplicated(df_dups),]
    adja_matrix = convert_longform(df0)
    adja_matrix <- as.data.frame(adja_matrix)
    rownames(adja_matrix) = adja_matrix[,1]
    adja_matrix = adja_matrix[,2:ncol(adja_matrix)]
    return(adja_matrix)
    
  }else{
    
    dataset <- dataset1()
    rownames(dataset) = dataset[,1]
    dataset = dataset[,2:ncol(dataset)]
    return(dataset)
  }
  
})

# displaying option to select UID and Item Id #

cols <- reactive({colnames(dataset1())})

output$user_ui <- renderUI({
  if(input$adj){
    return(NULL)
  }else{
    selectInput("uid","Select User ID",choices = cols(),multiple = FALSE)
  }
})

item_cols <- reactive({
  x <- match(input$uid,cols())
  item <- cols()[-x]
  return(item)
})

output$item_ui <- renderUI({
  if(input$adj){
    return(NULL)
  }else{
    selectInput("iid","Select Item ID",choices = item_cols(),multiple = FALSE)
  }
})

ratings_cols <- reactive({
  remove <- c(input$uid,input$iid)
  ratings <- cols()[!cols() %in% remove]
  if(length(ratings)==0){
    ratings <- NA
  }
  return(ratings)
})

output$rating_ui <- renderUI({
  if(input$adj){
    return(NULL)
  }else{
    selectInput("rat_id","Select Rating ID",choices = c(ratings_cols(),"NA"),multiple = FALSE)
  }
})

#----Selecting Focal User-------  
output$focal_list <- renderUI({
  if (is.null(input$file)) {return(NULL)}
  else{
    
    users_list <- rownames(dataset())
    selectInput(
      inputId = "Id084",
      label = "Select Focal User", 
      choices = users_list#,
     # options = list(`live-search` = TRUE)
    )
  }
})
  
#-----Descriptive Tab-----

output$dim <- renderText({
  if (is.null(input$file)) {return(NULL)}
  else{
    if(input$adj){
      size <- dim(dataset())
      return(paste0("Uploaded Adjaceny Matrix has ",size[1]," (rows) "," X ",size[2]," (columns)"))
    }else{
      size <- dim(dataset1())
      return(paste0("Uploaded Dataset has ",size[1]," (rows) "," X ",size[2]," (columns)"))
    }
    
  }
  
  
})  
  

output$dtm_head <- renderDataTable({
  req(dataset())
  if(input$adj){
    return(NULL)
  }else{
    return(dataset()[1:10,1:10])
  }
  
})


output$freq_table <- renderDataTable({
  if (is.null(input$file)) {return(NULL)}
  else{
    dtm <- dataset()
   
    
    a0 = colSums(dtm)
    a1 = sort(a0, decreasing=TRUE, index.return=TRUE)
    a2 = as.matrix(a0[a1$ix])
    token_freqs = data.frame(freq = a2)
    token_freqs$word = rownames(token_freqs)
    # reorder by column name
    token_freqs <- token_freqs[c("word", "freq")]  #return(as.data.frame(head(token_freqs, 10))) # 2nd output. Sorted freqs
    rownames(token_freqs) <- NULL
    head(token_freqs,10)

  }
})
#----------IBFC Recommendation-----------
  
  output$ibfc_re <- DT::renderDataTable({
    if (is.null(input$file)) {return(NULL)}
    else{
      progress <- Progress$new(session, min=1, max=10)
      progress$set(value=4,paste0("Calculating IBFC recommendation for focal user ",input$Id084))
      CF.list = dtm2CF(dataset(), input$Id084, 12)
      progress$set(value=8,"Done")
      on.exit(progress$close())
      #CF.list = dtm2CF(dataset(), input$Id084, 12)
      ibcf.brands = CF.list[[1]]
      DT::datatable(ibcf.brands, options = list(pageLength = 10))
     
    }
   
  })
  
output$ubfc_re <- DT::renderDataTable({
  if (is.null(input$file)) {return(NULL)}
  else{
    progress <- Progress$new(session, min=1, max=10)
    progress$set(value=4,paste0("Calculating UBFC recommendation for focal user ",input$Id084))
    CF.list = dtm2CF(dataset(), input$Id084, 12)
    progress$set(value=8,"Done")
    on.exit(progress$close())
    #CF.list = dtm2CF(dataset(), input$Id084, 12)
    ibcf.brands = CF.list[[2]]
    DT::datatable(ibcf.brands, options = list(pageLength = 10))
  }

})

output$sim_usr <- DT::renderDataTable({
  if (is.null(input$file)) {return(NULL)}
  else{
    progress <- Progress$new(session, min=1, max=10)
    progress$set(value=4,paste0("Finding similar user for focal user ",input$Id084))
    CF.list = dtm2CF(dataset(), input$Id084, 12)
    progress$set(value=8,"Done")
    on.exit(progress$close())
    #CF.list = dtm2CF(dataset(), input$Id084, 12)
    simil.users = CF.list[[3]]
    DT::datatable(simil.users, options = list(pageLength = 10))
  }
  
})




output$downloadData1 <- downloadHandler(
  filename = function() { "recommendation_system_input.csv" },
  content = function(file) {
    write.csv(read.csv("data/B2C brands pgp21_dtm.csv"), file,row.names = FALSE)
  }
)

  
})


  
  
  
  
  
