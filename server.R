
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library('shiny')
library('dplyr')
library('png')

load('./grids/Grids.Rdata')
load('./results/RSA/OpeningWindow/raw/Dilkina/growl2/allitems/performance/final_weights.Rdata')
Weights <- left_join(Weights,Grids)
Weights$labels <- as.factor(Weights$labels)
Weights$timestampsADJ <- Weights$timestamps * Weights$boxcar
MAPS <- list()
for (i in 1:10) {
    MAPS[[i]] <- png::readPNG(file.path('maps',sprintf("Map_Pt%02d.png", i)))
}

composeWeightSummary <- function(w1,w2,w3,valueType) {
    l2norm <- function(x) norm(as.matrix(x), type = '2')
    W <- cbind(w1,w2,w3)
    if (valueType == 'w1') value = w1
    else if (valueType == 'w2') value = w2
    else if (valueType == 'w3') value = w3
    else if (valueType == 'sum') value = rowSums(W)
    else if (valueType == 'sumMagnitude') value = rowSums(abs(W))
    else if (valueType == 'mean') value = rowMeans(W)
    else if (valueType == 'meanMagnitude') value = rowMeans(abs(W))
    else if (valueType == 'l2norm') value = apply(W, 1, l2norm)
    else if (valueType == 'strength') value = rowSums(abs(W %*% t(W)))
    else if (valueType == 'degree') value = rowSums(abs(W %*% t(W))>0)
    return(value)
}
aggregateMethod <- function(x,method) {
    if (method == 'sum') y = sum(x)
    else if (method == 'sumMagnitude') y = sum(abs(x))
    else if (method == 'mean') y = mean(x)
    else if (method == 'meanMagnitude') y = mean(abs(x))
    return(y)
}
pickColorMap <- function(label) {
    if (label == 'red to yellow') {
        cmap <- colorRamp(c('red','yellow'))
    } else if (label == 'blue->green->red') {
        cmap <- colorRamp(c('blue','green','red'))
    }
}
colormapper <- function(x, cmap, bottom, top) {
    if (is.na(bottom) || is.null(bottom))
        bottom <- min(x)
    x <- x - bottom

    if (is.na(top) || is.null(top))
        top <- max(x)
    else
        top <- top - bottom
    x <- x / top
    x[x<0] <- 0
    x[x>1] <- 1
    rgbhex <- cmap(x)
    return(rgbhex)
}
shinyServer(function(input, output) {

    figTitle <- eventReactive(input$generatePlot, {
        sprintf("Pt%02d electrode grids", as.numeric(input$subject))
    })

    img <- eventReactive(input$generatePlot, {
        MAPS[[as.numeric(input$subject)]]
    })

    dataToPlot <- eventReactive(input$generatePlot, {
        d <- filter(
            Weights,
            subject == as.numeric(input$subject),
            windowsize == as.numeric(input$WindowSize),
            timestampsADJ >= as.numeric(input$includeTimeA),
            timestampsADJ <= as.numeric(input$includeTimeB)
        )

        cmap <- pickColorMap(input$colorMapLabel)

        d <- d %>%
            group_by(subject, windowsize, labels, xr, yr) %>%
            mutate(value = composeWeightSummary(w1,w2,w3,input$valueType)) %>%
            summarize(value = aggregateMethod(value, input$aggregateMethod)) %>%
            ungroup()
        if (input$positiveOnly) {
            d <- filter(d, value > 0)
        }
        if (!is.na(input$threshold)) {
            d <- filter(d, abs(value) > input$threshold)
        }
        tmp <- colormapper(d$value, cmap, as.numeric(input$colorscale.bottom), as.numeric(input$colorscale.top))/255
        d$rgbhex = rgb(tmp[,1],tmp[,2],tmp[,3])
        return(d)
    })

    output$electrodePlot <- renderPlot({
        d.avg <- dataToPlot()
        plot(0, type='n', xlim=c(0,350), ylim=c(0,350), main=figTitle(), xlab='x',ylab='y')
        rasterImage(img(), 0, 0, 350, 350)
        points(d.avg$xr,d.avg$yr,cex=2.2,bg=d.avg$rgbhex, pch=21)
    })

    output$electrodeSummary <- renderDataTable({
        d.avg <- dataToPlot()
        d.avg %>%
            summarize(
                min = min(value),
                max = max(value),
                mean = mean(value),
                median = median(value)
            )
    })

    output$electrodeRaw <- renderDataTable({
        d.avg <- dataToPlot()
        d.avg
    })
})
