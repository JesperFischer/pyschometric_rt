# Define server
server <- function(input, output) {
  
  set.seed(123)
  
  output$visualize_psychometric <- renderPlot({
    
    
    parameters = data.frame(threshold = input$threshold, slope = input$slope,lapse = input$lapse,
                            rt_int = input$rt_int, rt_beta = input$rt_beta, rt_sd = input$rt_sd,
                            rt_shift = input$rt_shift, minRT = input$minRT,
                            participant = 1, stimulus = "random")
    
    df = simulate_psychometric(parameters, seed = 123)
    
    plot = plot_joint_rts_single_v2(df)
    return(plot)
    
    
  })

  
}

