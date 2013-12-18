library(shiny)
library(rCharts)
 
options(RCHART_LIB = 'polycharts')
 
shinyUI(pageWithSidebar(
  headerPanel("China Mapping Application"),
  sidebarPanel(
    #   Give directions  
    h4('Directions:'),
    HTML('<p>Use this tool to make chloropleths of Chinese province level data. First, name your plot and choose
         the name of the column you would like to plot (these can also be changed later). Then, upload the csv file with your
         data. The requirement is that the column identifying each province <b>must be titled "District"</b>, and that the province names
         are spelled as listed at the bottom*.<br><br>
         Once you upload your data, your file will be displayed in the Data tab. After adding a plot title and choosing the variable to plot, 
         the map will show up in the Map tab. In addition, an interactive bar chart with show up in the Barchart tab</p>'),
    tags$hr(),
    h4('Plotting Options'),  
    textInput('title', 'Please enter the plot title before uploading'),
    textInput('var', 'Indicate which variable you wish to plot'),
    radioButtons('color', 'Color Scheme:',
                 c(RdBu = 'RdBu',
                   Blues = 'Blues'),
                 'RdBu'),
    fileInput('file1', 'Choose CSV File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain')),
    tags$hr(),
    h4('CSV Uploading Options'),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator',
                 c(Comma=',',
                   Semicolon=';',
                   Tab='\t'),
                 'Comma'),
    radioButtons('quote', 'Quote',
                 c(None='',
                   'Double Quote'='"',
                   'Single Quote'="'"),
                 'Double Quote'),
    tags$hr(),
    h4('Approved Names'),
    HTML('<p>Anhui<br>',
         'Beijing<br>',
         'Chongqing<br>',
         'Fujian<br>',
         'Gansu<br>',
         'Guangdong<br>',
         'Guangxi<br>',
         'Guizhou<br>',
         'Hainan<br>',
         'Hebei<br>',
         'Heilongjiang<br>',
         'Henan<br>',
         'Hubei<br>',
         'Hunan<br>',
         'Jiangsu<br>',
         'Jiangxi<br>',
         'Jilin<br>',
         'Liaoning<br>',
         'Nei Mongol/Inner Mongolia<br>',
         'Ningxia Hui/Ningxia<br>',
         'Paracel Islands<br>',
         'Qinghai<br>',
         'Shaanxi<br>',
         'Shandong<br>',
         'Shanghai<br>',
         'Shanxi<br>',
         'Sichuan<br>',
         'Tianjin<br>',
         'Xinjiang Uygur/Xinjiang<br>',
         'Xizang/Tibet<br>',
         'Yunnan<br>',
         'Zhejiang</p>')
    ),
  mainPanel(
    tabsetPanel(
      tabPanel("Data", tableOutput('contents')),
      tabPanel("Map", plotOutput('mapImage')),
      tabPanel("Barchart", showOutput('barImage', 'polycharts'))
    )
  )
  ))