library(shiny)

ui <- fluidPage(
  titlePanel("Histogram of random data"),
  sidebarPanel(
    sliderInput("k",
                "Number of observations",
                min = 100,
                max = 10000,
                value = 1000,
                step = 100),
    radioButtons("type",
                 "Distribution type",
                 choices = c("Uniform", "Normal", "Log-normal"),
                 selected = "Uniform")),
  mainPanel(
    plotOutput("hist")
  )
)

server <- function(input, output) {
  output$hist <- renderPlot({
    if (input$type == "Uniform") {
      hist(runif(input$k))
    } else if (input$type == "Normal") {
      hist(rnorm(input$k))
    } else if (input$type == "Log-normal") {
      hist(rlnorm(input$k))
    }
  })
}

shinyApp(ui, server)