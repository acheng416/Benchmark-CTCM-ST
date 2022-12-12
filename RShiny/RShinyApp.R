library(plotly)
library(htmlwidgets)
#library(shiny)
library(shinyFiles)
library(hash)
library(RColorBrewer)
library(stringr)

# Use UI from front-end.R
source(file.path(getwd(),"Rshiny", "frontend.R"))
# Get preprocessing funcs from backend
source(file.path(getwd(),"Rshiny", "backend.R"))

server <- function(session, input, output) {
  vals <- shiny::reactiveValues( 
                        cluster_index = 0,
                        cls = NULL,
                        spatial_df = NULL,
                        selected_pts = NULL,
                        save_path = NULL
                        )
  cluster = reactive({
    #' Sets cluster_index as cluster selected by User
    input$cl_choice
  })

  # observeEvent(input$cl_choice, {
  #   #' Callback to load clusters from a file given by User
  #   cl_path = input$cl_file$datapath
  #   cls = readRDS(cl_path)
  #   vals$cls = process_cl(cls)
  # })

  observeEvent(input$cl_file, {
    #' Callback to load clusters from a file given by User
    cl_path = input$cl_file$datapath
    cls = readRDS(cl_path)
    vals$cls = process_cl(cls)
    choices = sort(vals$cls, decreasing=F)
    updateSelectInput(session, "cl_choice", choices = choices , selected = choices[1])
  })

  observeEvent(input$spatial_file, {
    #' Callback to load spatial information from a file given by User
    spatial_path = input$spatial_file$datapath
    vals$spatial_df = handle_filetype(spatial_path)
  })

  data = reactive({
    if(!is.null(vals$spatial_df)){
      spatial_info = vals$spatial_df
      data = data.frame(x=spatial_info$x, y=spatial_info$y, color=vals$cls)
      fig = plot_ly(type="scatter",mode="markers",data = data, x = ~x, y = ~y, color = ~color, size=5)
    } else{fig=NULL}
    return(fig)
  })

  output$distPlot <- renderPlotly({
      return(data())
  })

  output$selected <- renderPrint({
    vals$selected_pts = data.frame(event_data("plotly_selected"))
    print(vals$selected_pts)
  })

  observeEvent(input$paint_selected, {
    selected_df = vals$selected_pts[,3:4]
    spatial_info = vals$spatial_df
    matched = match(
      interaction(selected_df$x, selected_df$y),
      interaction(spatial_info$x, spatial_info$y)
    );
    print(vals$cls)
    
    vals$cls[matched] = cluster()
    print(vals$cls)
    print(cluster())
  })

  observeEvent(input$add_cl, {
    old_levels = c(levels(vals$cls))
    print(length(old_levels))
    new_cl = as.character(as.numeric(length(old_levels))+1)
    print(new_cl)
    choices = sort(c(old_levels,  new_cl), decreasing = F)
    print(choices)
    vals$cls = factor(vals$cls, levels=choices)
    #print(vals$cls)
    updateSelectInput(session, "cl_choice", choices = choices , selected = choices[1])
  })

  
  # observe({
  #   shinyDirChoose(input, "save", roots=c(folder=getwd()), session=session)
  #   vals$save_path <- parseSavePath(c(folder=getwd()), input$save)$datapath
  # })

  observe({
    shinyFileSave(input, "save_file", roots=c(folder=getwd()), session=session)
    vals$save_path <- parseSavePath(c(folder=getwd()), input$save_file)$datapath
    print(vals$save_file)
  })
  # observeEvent(input$delete_cl,{
  #   #Remove selected cluster
  #   if((cluster_index() - 1) > 0 ){
  #     vals$to_plot_zp[ vals$to_plot_zp[,3] %in% vals$select_cluster[cluster_index()] , 3]  = vals$select_cluster[cluster_index() - 1]
      
  #     #Drop unused levels
  #     vals$to_plot_zp[,3] = droplevels(vals$to_plot_zp[,3])
      
  #     #Update selection options
  #     vals$select_cluster <- levels(vals$to_plot_zp[,3])
  #     updateSelectInput(session, "cl_choice",
  #                       choices = vals$select_cluster, selected = "")
  #   }else{
  #     print("Cannot have less than one cluster") 
  #   }
  # })
  
  
  # observeEvent(input$save_file,{
  #   #print(sprintf("%s.rds", vals$save_path))
  #   trueDataset = vals$trueDataset
  #   true_cl = as.factor(vals$to_plot_zp[,3])
  #   names(true_cl) = cell_names(trueDataset)
  #   trueDataset = addClusters(trueDataset, "true_cl", true_cl)
  #   saveRDS(trueDataset, sprintf("%s/trueDataset.rds", vals$save_path) )
  #   output$save_progress <-  renderText("Saved!")
  # })
  
  # output$distPlot <- renderPlot({
  #   plot = ggplot(  vals$to_plot_zp, aes(x= x, y = y, color=  inferred_cell_types )) +  
  #     geom_point(size=10 ) + scale_y_reverse()
  #     #theme_classic() + scale_color_manual(values = colorRampPalette(brewer.pal(8,"Set2"))(length(vals$select_cluster )))
  #     if(sum(as.character(vals$to_plot_zp$inferred_cell_types) == "Unassigned") == 0){
  #     plot = plot + theme_classic() + scale_color_manual(values = c(colorRampPalette(brewer.pal(8,"Set2"))(10)) )
  #     } else{
  #     plot = plot +   theme_classic() + scale_color_manual(values = c("#E4E4E4", colorRampPalette(brewer.pal(8,"Set2"))(10)) )
  #     }
  #  plot
  # }, height = 500, width = 600)
  
  # output$hover_info <- renderPrint({
  #   cat("input$plot_hover:\n")
  #   #nearPoints(mtcars, input$plot_click)
  #   str(nearPoints(vals$to_plot_zp, input$plot_hover, xvar="x", yvar = "y", threshold = 3  ) )
  # })
}

shinyApp(ui = ui, server = server)
