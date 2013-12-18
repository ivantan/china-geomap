library(shiny)
library(maptools)
library(maps)
library(sp)
library(RColorBrewer)
library(rCharts)
 
changeName = function(dataInput){
  dataInput$District = factor(dataInput$District)  
  
  #Allow for alternate naming
  dataNames = levels(dataInput$District)
  
  dataNames[which(dataNames == 'Ningxia')] = 'Ningxia Hui'
  dataNames[which(dataNames == 'Xinjiang')] = 'Xinjiang Uygur'
  dataNames[which(dataNames == 'Tibet')] = 'Xizang'
  dataNames[which(dataNames == 'Inner Mongolia')] = 'Nei Mongol'
  
  levels(dataInput$District) = dataNames    
  
  return(dataInput)  
}
 
cleanData = function(dataInput, input){
  
  dataInput = subset(dataInput, select = c('District', input$var))
  dataInput = dataInput[complete.cases(dataInput),]
  
  dataInput = changeName(dataInput)
  return(dataInput)
}
 
readData = function(input){
  inFile = input$file1  
  if (is.null(inFile))
    return(NULL)
  dataInput <- read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote, stringsAsFactors = F)
  #Terminate if the variable isn't in the file
  if(!(input$var %in% names(dataInput))) return(NULL)
  
  return(dataInput)
}
 
shinyServer(function(input, output){
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    df = read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
#     return(df[-is.na(df$District),])
  })
  output$mapImage <- renderPlot({
  
    print('Rendering Map')
    
    START = proc.time()[3]  
    
    dataInput = readData(input)
    if(is.null(dataInput))
      return(NULL)
    dataInput = cleanData(dataInput, input)
    
    #Load the China map from the GADM database
    print('Downloading Map')
    mapchina <- url("http://www.gadm.org/data/rda/CHN_adm1.RData")
    print('Map is completed')
    load(mapchina)
    close(mapchina)
    
    #Get a data frame of the names of the regions in the GADM map
    gadmNames = gadm$NAME_1
    df.names = data.frame(District = gadmNames)
    gadm@data = merge(df.names, dataInput, all.x = TRUE)
    
    print(gadm@data)
    
    mapPlot = spplot(gadm, c(input$var),
                     main = input$title,  
                     col.regions = adjustcolor(colorRampPalette(brewer.pal(9, input$color))(100), 0.85))
    END = proc.time()[3]
    
    print(paste('Time elapsed:', round(END - START, 2)))
    
    print(mapPlot)
  })
  
  output$barImage <- renderChart({
    print('Rendering bars')
    
    START = proc.time()[3]
    
    dataInput = readData(input)
    if(is.null(dataInput))
      return(NULL)
    dataInput = cleanData(dataInput, input)
    coast = changeName(read.csv('coastGeo.csv'))
    dataInput = merge(dataInput, coast, all.x = T)
    dataInput$Geo = factor(dataInput$Coastal, labels = c('Inland', 'Coastal'))  
    bar = rPlot(x = list(var = 'District', sort = input$var), 
                y = input$var, 
                data = dataInput, 
                color = 'Geo',
                type = 'bar')
    bar$addParams(height = 500, dom = 'barImage', 
                   title = input$title)
    bar$guides(x = list(title = ""))
    
    END = proc.time()[3]
    
    print(paste('Time elapsed:', round(END - START, 2)))
    
    return(bar)  
  })
})