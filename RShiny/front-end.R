library(shiny)

ui <- fluidPage(
  sidebarLayout(
    
    sidebarPanel(

      #Dropdown for cluster
      selectInput("cl_choice", "Select a cluster label", choices = "" ),
      
      #File selector
      fileInput("file", "Upload file"),
      shinyDirButton("save", "Select folder to save", "Select"),
      actionButton("save_file", "Save"),
      actionButton("add_cl", "Add a cluster"),
      actionButton("delete_cl", "Delete selected cluster"),
      verbatimTextOutput("save_progress"),
      verbatimTextOutput("hover_info")
    ),
    mainPanel(
      plotOutput("distPlot",
                 click = "plot_click",
                 hover = hoverOpts(
                   id = "plot_hover",
                   delay = 10,
                 )),
      #plotOutput("RGB_img"),
    )
  )
)