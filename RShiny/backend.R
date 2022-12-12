library("tools")

process_cl <-function(cls){
    # Given a raw cl values process them as factors
    cls = factor(cls, levels = sort(unique(cls), decreasing = F))
    names(cls) = NULL
    #print(cls)
    return(cls)
}
process_spatial <-function(spatial_info){
    # Given raw spatial x, y pixel-mapped locations,
    # returns dataframe with processed spatial coordinates
    spatial_df = data.frame(spatial_info)
    if(NCOL(spatial_df) == 3){
        spatial_df = spatial_df[,2:3]
    }
    colnames(spatial_df) = c("x", "y")
    return(spatial_df)
}

handle_filetype <-function(path){
    ext = file_ext(path)
    if(ext == "tsv"){
        spatial_info = read.csv(file=path,sep='\t')
    } else if(ext == "csv"){
        spatial_info = read.csv(file=path)
    } else{
        spatial_info = readRDS(path)
    }
    return(process_spatial(spatial_info))
}