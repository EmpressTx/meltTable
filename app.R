#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(reshape2)
library(DT)

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("plate map reformatter"),
    textAreaInput("map", "Paste plate map here:", "", width = "1000px"),
    textAreaInput("data", "Paste 96 well data here:", "", width = "1000px"),
    dataTableOutput('table'),
)

# Define server logic
server <- function(input, output) {
    output$table <- renderDataTable({
        platemap <- read.table(text=input$map, sep="\t", check.names=FALSE, header=TRUE)
        platedata <- read.table(text=input$data, sep="\t", check.names=FALSE, header=TRUE)
        melted_platemap <- melt(platemap,id.vars=1)
        melted_platedata <- melt(platedata, id.vars=1)
        melted_df <- cbind(melted_platemap, melted_platedata[,3])
        colnames(melted_df) <- c("Row", "Col", "Label", "Value")
        datatable(melted_df, 
                  extensions = 'Buttons', 
                  rownames=FALSE,
                  options = list(dom = 'Blfrtip',
                                 buttons = list(
                                     list(
                                         extend="copy",
                                         text="Copy",
                                         title=NULL
                                     )
                                 ),
                                 paging = FALSE,
                                 searching = FALSE,
                                 pageLength = 96))
        })
}

# Run the application 
shinyApp(ui = ui, server = server)
