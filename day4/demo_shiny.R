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
  get_data <- reactive({
    type <- input$type
    k <- input$k
    fun = switch(type, Uniform = runif, Normal = rnorm, 'Log-normal' = rlnorm)
    fun(k)
  })
  output$hist <- renderPlot({
    data <- get_data()
    hist(data)
  })
}


shinyApp(ui, server)