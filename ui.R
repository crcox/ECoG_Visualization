
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

    # Application title
    titlePanel("ECoG Model Visualization"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("subject", "Select subject:", choices = c(1,2,3,5,7,8,9,10), multiple = FALSE),
            sliderInput("WindowSize",
                        "Model Window Size:",
                        min = 100,
                        max = 1000,
                        step = 100,
                        value = 1000),
            numericInput("includeTimeA", "Include weights from time points as early as:", 0, min = 0, max = 1000, step = 100),
            numericInput("includeTimeB", "Include weights from time points as Late as:", 1000, min = 0, max = 1000, step = 100),
            selectInput("colorMapLabel", "Choose colormap:", choices = c("red to yellow","blue->green->red"), multiple = FALSE),
            numericInput("colorscale.bottom", "Bottom of color scale:", value = NA),
            numericInput("colorscale.top", "Top of color scale:", value = NA),
            selectInput("valueType", "Value to display at each electrode:", choices = c(
                'Weight on dimension 1' = 'w1',
                'Weight on dimension 2' = 'w2',
                'Weight on dimension 3' = 'w3',
                'Sum over weighted dimensions' = 'sum',
                'Mean over weighted dimensions' = 'mean',
                'Sum over magnitude of weighted dimensions' = 'sumMagnitude',
                'Mean over magnitude of weighted dimensions' = 'meanMagnitude',
                'L2-norm over weighted dimensions' = 'l2norm',
                'Node-strength' = 'strength',
                'Node-degree' = 'degree'
            )),
            selectInput("aggregateMethod", "How to aggregate over time:", choices = c(
                'Sum' = 'sum',
                'Mean' = 'mean',
                'Sum of magnitude' = 'sumMagnitude',
                'Mean of magnitude' = 'meanMagnitude'
            )),
            checkboxInput("positiveOnly", "Display only positive values?", value = FALSE, width = NULL),
            numericInput("threshold", "Apply magnitude threshold:", value = NA)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            actionButton('generatePlot','Generate Plot'),
            plotOutput("electrodePlot"),
            dataTableOutput("electrodeSummary"),
            dataTableOutput("electrodeRaw")
        )
    )
))
