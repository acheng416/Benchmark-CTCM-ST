library(shiny)

ui <- fluidPage(
  sidebarLayout(
    
    sidebarPanel(

      #Dropdown for cluster
      selectInput("cl_choice", "Select a cluster label", choices = ""),
      
      #Clusters to load
      fileInput("cl_file", "Upload .rds file containing clusters", accept = ".rds"),
      fileInput("spatial_file", "Upload file containing spatial coordinates", accept = c(".rds", ".tsv", ".csv")),
      shinySaveButton("save_file", "Save File", "Save as...", filetype=list(xlsx="xlsx")),
      actionButton("add_cl", "Add a cluster"),
      actionButton("delete_cl", "Delete selected cluster"),
      selectInput("paint_type", "Select method of painting", choices = list("click", "lasso")),
      actionButton("paint_selected", "Paint selected"),
    ),
    mainPanel(
      plotlyOutput("distPlot",
      width = "50%", height = "50%"),
    )
  )
)