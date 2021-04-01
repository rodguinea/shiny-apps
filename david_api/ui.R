library(shiny)
library(ggplot2)

fluidPage(
    
    fluidRow(
        column(2, style='padding:3px;',
               
               fileInput("file2", "Upload Seed Genes",
                         multiple = FALSE,
                         accept = c("text/csv",
                                    "text/comma-separated-values,text/plain",
                                    ".csv")),
               fileInput("file1", "Upload Co-expressed Genes",
                         multiple = FALSE,
                         accept = c("text/csv",
                                    "text/comma-separated-values,text/plain",
                                    ".csv")),
               selectInput("cluster",
                           "Cluster:",
                           c("All", "Cluster 1", "Cluster 2"))
        )
    ),
    
    DT::dataTableOutput("table")
)

