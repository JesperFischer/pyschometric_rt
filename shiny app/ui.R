

# Define UI
ui <- navbarPage(
  "Parameters",
  tabPanel("Single learning subject", 
           sidebarLayout(
             sidebarPanel(
               sliderInput("threshold", "threshold", min = -10, max = 10, value = 5, step = 0.01),
               sliderInput("slope", "slope", min = 0, max = 10, value = 4, step = 0.01),
               sliderInput("lapse", "lapse", min = 0, max = 0.5, value = 0.05, step = 0.01),
               sliderInput("rt_int", "rt_int", min = -3, max = 3, value = 0, step = 0.01),
               sliderInput("rt_beta", "rt_beta", min = -1, max = 10, value = 5, step = 0.01),
               sliderInput("rt_sd", "rt_sd", min = 0, max = 1, value = 0.5, step = 0.01),
               sliderInput("rt_shift", "rt_shift", min = 0, max = 1, value = 0.5, step = 0.01),
               sliderInput("minRT", "minRT", min = 0, max = 0.5, value = 0.2, step = 0.01)
             ),
             mainPanel(
               plotOutput("visualize_psychometric", height = "900px")
             )
           )
  )
)



