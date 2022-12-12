library(shiny)

ui <- fluidPage(
  sidebarLayout(
    
    sidebarPanel(

      #Dropdown for cluster
      selectInput("cl_choice", "Select a cluster label", choices = ""),
      
      #Clusters to load
      fileInput("cl_file", "Upload .rds file containing clusters", accept = ".rds"),
      fileInput("spatial_file", "Upload file containing spatial coordinates", accept = c(".rds", ".tsv", ".csv")),
      shinySaveButton("save_file", "Save", "Save as..."),
      actionButton("add_cl", "Add a cluster"),
      actionButton("delete_cl", "Delete selected cluster"),
      verbatimTextOutput("selected"),
      actionButton("paint_selected", "Paint selected"),
    ),
    mainPanel(
      plotlyOutput("distPlot",
      width = "50%", height = "50%",
                #  click = "plot_click",
                #  hover = hoverOpts(
                #    id = "plot_hover",
                #    delay = 10,
                #  )
                 ),
      #plotOutput("RGB_img"),
    )
  )
)