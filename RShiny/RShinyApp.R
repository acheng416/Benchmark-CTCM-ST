library(plotly)
library(htmlwidgets)
#library(shiny)
library(shinyFiles)
library(hash)
library(RColorBrewer)
library(stringr)
#library("docstring")
#library("config")

#Use UI from front-end.R
source(file.path(getwd(),"Rshiny", "front-end.R"))

server <- function(session, input, output) {
  #options(shiny.maxRequestSize=1000*1024^2)
  vals = reactiveValues( 
                        cluster_index = 0
                        # to_plot_zp = NULL, select_cluster = NULL, 
                        # , save_path = NULL, selected = c(),  
                        # , use_click = FALSE , start_hover = FALSE, trueDataset = NULL, jobQ = NULL
                        )
  
  cluster_index = reactive({
    #' Sets cluster_index as cluster selected by User
    as.numeric(input$cl_choice) 
  })
  
  # observeEvent(input$add_cl,{
  #   unique_cl = unique(vals$to_plot_zp[,3])
  #   #print(unique_cl)
  #   ncls = length(unique_cl)
  #   new_unique = c( as.character(unique_cl), as.character(ncls) )
  #   #print(new_unique)
  #   #print(sort(new_unique[new_unique!="Unassigned"]))
  #   vals$to_plot_zp[,3] = factor(vals$to_plot_zp[,3] , levels = c("Unassigned",sort(new_unique[new_unique!="Unassigned"]))  )
  #   vals$select_cluster <- levels(vals$to_plot_zp[,3])
  #   updateSelectInput(session, "cl_choice",
  #                     choices = vals$select_cluster, selected = "")
  # })
  
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
  
  # observeEvent(input$file, {
  #   vals$save_path <- input$file$datapath
  #   trueDataset = readRDS(input$file$datapath)
  #   #View(trueDataset)
  #   spatial = spatial(trueDataset)
  #   print(spatial)
  #   #print(head(spatial, 10))
  #   print(trueDataset@clusters)
  #   cl = trueDataset@clusters[['true_cl']]
  #   print(cl)
  #   vals$trueDataset = trueDataset
    
  #   new = data.frame(x = trueDataset@x_pixel , y = trueDataset@y_pixel , inferred_cell_types = rep("Unassigned", NROW(cl))  )
    
  #   #new = data.frame(x = spatial[,1] , y = spatial[,2] , inferred_cell_types = rep("Unassigned", NROW(cl))  )
  #   #print(new)
  #   #new[,3] = mapvalues(new[,3], from = unique(new[,3]), to = sort(as.numeric(unique(new[,3]) ) ) )
  #   #print(table(new[,3]))#
  #   new[,3] = factor(new[,3], levels = c("Unassigned", sort(as.numeric(unique(cl) ))) )
  #   print(new[,3])
  #   vals$to_plot_zp <- new
    
  #   vals$select_cluster <- levels(vals$to_plot_zp[,3])
  #   updateSelectInput(session, "cl_choice",
  #                     choices = levels(vals$to_plot_zp[,3]), selected = "")
  # })
  
  # observeEvent(input$plot_click, {
  #   #new_x = input$plot_click$x
  #   #new_y = input$plot_click$y
  #   if(vals$start_hover == FALSE){
  #     vals$start_hover = TRUE
  #     #Reset queue
  #     vals$jobQ = queue()
  #     gc()
  #   } else{
  #     #Was hovering -> Now process jobQ in parallel
  #     q = vals$jobQ
  #     doneHash = hash()
  #     cell_strs = rownames(vals$to_plot_zp)
  #     for(i in 1:NROW(cell_strs )){
  #       doneHash[[cell_strs[i]]]<-FALSE
  #     }
  #     jobList = as.list(q)
      
  #     for(i in 1:length(jobList)){
  #       #Skip if cell already painted
  #       curr_cell_names_V =  rownames(jobList[[i]])
  #       #print(curr_cell_names_V)
  #       for(j in 1:NROW(curr_cell_names_V)){
  #         curr_cell_name = curr_cell_names_V[j]
  #         done = doneHash[[curr_cell_name]]
  #         if(done){
  #           next
  #         } else{
  #           vals$to_plot_zp[!is.na(fmatch(rownames(vals$to_plot_zp), curr_cell_name )) , 3] = vals$select_cluster[cluster_index()+1]
  #           doneHash[[curr_cell_name]] = TRUE
  #         }
  #       }
  #     }
  #     vals$start_hover = FALSE 
  #   }
  # })
  
  # observeEvent(input$plot_hover, {
  #   #new_x = input$plot_click$x
  #   #new_y = input$plot_click$y
  #   if(vals$use_click == FALSE && vals$start_hover == TRUE){
  #     selected = nearPoints(vals$to_plot_zp, input$plot_hover, xvar="x", yvar = "y", threshold = 10  )
  #     #print(length(rownames(selected)) )
  #     #print(NROW(selected[,3]) )
  #     x_cord = selected$x[1]
  #     #y_cord = selected$y[1]
  #     if(!is.na(x_cord)){
  #       pushback(vals$jobQ, selected)
  #       #print(sprintf("%s , %s", x, y))
  #       #print(vals$to_plot_zp[rownames(selected) == rownames(vals$to_plot_zp)  , 3])
  #       #print(vals$select_cluster[cluster_index()])
  #       #print(vals$to_plot_zp[rownames(selected) == rownames(vals$to_plot_zp)  , 3])
  #       #print(vals$to_plot_zp[,1:2])
  #       #print()
  #       # print(!is.na(fmatch(rownames(vals$to_plot_zp), rownames(selected) )))
  #       #vals$to_plot_zp[!is.na(fmatch(rownames(vals$to_plot_zp), rownames(selected) )) , 3] = vals$select_cluster[cluster_index()]
  #       #select_rows = rownames(selected) == rownames(vals$to_plot_zp)
  #       #vals$to_plot_zp[select_rows  , 3] = vals$select_cluster[cluster_index()]
  #     }
  #   }
  # })
  # observe({
  #   shinyDirChoose(input, "save", roots=c(folder=getwd()), session=session)
  #   vals$save_path <- parseSavePath(c(folder=getwd()), input$save)$datapath
  #   #print(fileinfo$datapath)
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
