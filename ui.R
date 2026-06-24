library(shiny)
library(bslib)

ui <- page_navbar(
  title = "Iris Predictor",
  theme = bs_theme(version = 5, bootswatch = "flatly"),

  nav_panel(
    "App",
    layout_sidebar(
      sidebar = sidebar(
        h4("Enter the flower measurements"),
        p("Use the sliders and click 'Predict species'."),
        sliderInput("sepal_length", "Sepal length (cm)", min = 4.0, max = 8.0, value = 5.8, step = 0.1),
        sliderInput("sepal_width",  "Sepal width (cm)", min = 2.0, max = 4.5, value = 3.0, step = 0.1),
        sliderInput("petal_length", "Petal length (cm)", min = 1.0, max = 7.0, value = 4.3, step = 0.1),
        sliderInput("petal_width",  "Petal width (cm)", min = 0.1, max = 2.5, value = 1.3, step = 0.1),
        radioButtons(
          "k",
          "Number of neighbors (k)",
          choices = c("3" = 3, "5" = 5, "7" = 7),
          selected = 5,
          inline = TRUE
        ),
        checkboxInput("show_table", "Show the 5 most similar flowers", value = TRUE),
        actionButton("predict", "Predict species", class = "btn-primary")
      ),

      card(
        card_header("Prediction result"),
        card_body(
          h3(textOutput("predicted_species"), class = "text-primary"),
          p(strong("Estimated confidence:"), textOutput("confidence", inline = TRUE)),
          hr(),
          p(textOutput("message"))
        )
      ),

      card(
        card_header("Comparison with the iris dataset"),
        plotOutput("scatter_plot", height = "420px")
      ),

      conditionalPanel(
        condition = "input.show_table == true",
        card(
          card_header("The 5 nearest flowers to the input case"),
          tableOutput("neighbors")
        )
      )
    )
  ),

  nav_panel(
    "How to use",
    card(
      card_header("Quick guide for first-time users"),
      card_body(
        tags$ol(
          tags$li("Go to the 'App' tab."),
          tags$li("Set the four flower measurements using the sliders."),
          tags$li("Choose how many neighbors to use (k = 3, 5, or 7)."),
          tags$li("Click the 'Predict species' button."),
          tags$li("Read the predicted species, the confidence value, and inspect the comparison plot."),
          tags$li("Optionally, show or hide the table of the 5 most similar flowers.")
        ),
        tags$h4("What do the results mean?"),
        tags$ul(
          tags$li("Predicted species: the most likely class among setosa, versicolor, and virginica."),
          tags$li("Estimated confidence: the share of nearest neighbors that belong to the winning class."),
          tags$li("Plot: shows the entered point in red together with the real observations from the iris dataset."),
          tags$li("Neighbors table: helps the user see which flowers in the dataset are most similar to the entered one.")
        ),
        tags$h4("When to use this app"),
        p("This application is useful for showing, in a simple way, how supervised classification works on a famous built-in R dataset. It does not replace real botanical analysis, but it is excellent for teaching and demonstration purposes."),
        tags$h4("Tips"),
        tags$ul(
          tags$li("If you are unsure which values to choose, keep the default values and change one measurement at a time."),
          tags$li("Lower k values make the prediction more sensitive to local cases; higher k values make it more stable."),
          tags$li("Notice how the prediction changes when you modify petal measurements: they are often highly informative.")
        )
      )
    )
  ),

  nav_panel(
    "Technical details",
    card(
      card_header("How the model works"),
      card_body(
        p("The app uses the built-in R dataset 'iris' and applies a k-nearest neighbors (k-NN) classifier."),
        tags$ul(
          tags$li("Input: 4 flower measurements plus the value of k."),
          tags$li("Server processing: variable standardization, distance computation, and classification."),
          tags$li("Reactive outputs: predicted species, confidence, plot, and neighbors table."),
          tags$li("The prediction is updated only when the user clicks the button, making the interaction easier to understand.")
        )
      )
    )
  )
)
