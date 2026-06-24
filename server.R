library(shiny)
library(ggplot2)
library(class)

server <- function(input, output, session) {
  iris_df <- iris

  model_input <- eventReactive(input$predict, {
    data.frame(
      Sepal.Length = input$sepal_length,
      Sepal.Width  = input$sepal_width,
      Petal.Length = input$petal_length,
      Petal.Width  = input$petal_width
    )
  })

  prediction <- eventReactive(input$predict, {
    new_obs <- model_input()

    train_x <- iris_df[, 1:4]
    test_x  <- new_obs

    # Standardize using training-set statistics
    mu <- sapply(train_x, mean)
    sdv <- sapply(train_x, sd)
    train_scaled <- scale(train_x, center = mu, scale = sdv)
    test_scaled  <- scale(test_x, center = mu, scale = sdv)

    k_val <- as.numeric(input$k)

    pred <- knn(
      train = train_scaled,
      test = test_scaled,
      cl = iris_df$Species,
      k = k_val,
      prob = TRUE
    )

    # In class::knn, 'prob' returns the proportion of the winning class
    conf <- attr(pred, "prob")

    # Compute distances to identify nearest neighbors
    dists <- sqrt(rowSums((sweep(train_scaled, 2, as.numeric(test_scaled), FUN = "-"))^2))
    idx <- order(dists)[1:5]
    neighbors <- iris_df[idx, ]
    neighbors$Distance <- round(dists[idx], 3)

    list(
      species = as.character(pred),
      confidence = round(as.numeric(conf) * 100, 1),
      neighbors = neighbors,
      new_point = new_obs
    )
  })

  output$predicted_species <- renderText({
    req(prediction())
    paste("Predicted species:", prediction()$species)
  })

  output$confidence <- renderText({
    req(prediction())
    paste0(prediction()$confidence, "%")
  })

  output$message <- renderText({
    req(prediction())
    species <- prediction()$species
    conf <- prediction()$confidence

    if (conf >= 80) {
      paste("The prediction is quite strong: the model recognizes the flower as", species, "with high agreement among the nearest neighbors.")
    } else if (conf >= 60) {
      paste("The prediction is moderately reliable: the most likely species is", species, ", but some nearest neighbors belong to other classes.")
    } else {
      paste("The prediction is uncertain: the nearest neighbors are mixed. The most likely species is still", species, ".")
    }
  })

  output$scatter_plot <- renderPlot({
    req(prediction())
    new_point <- prediction()$new_point

    ggplot(iris_df, aes(x = Petal.Length, y = Petal.Width, color = Species)) +
      geom_point(size = 2.5, alpha = 0.8) +
      geom_point(
        data = new_point,
        aes(x = Petal.Length, y = Petal.Width),
        inherit.aes = FALSE,
        color = "red",
        fill = "red",
        size = 4,
        shape = 8,
        stroke = 1.4
      ) +
      labs(
        title = "Iris dataset and the newly entered flower",
        subtitle = "The red point represents the flower to classify",
        x = "Petal length (cm)",
        y = "Petal width (cm)",
        color = "Species"
      ) +
      theme_minimal(base_size = 13)
  })

  output$neighbors <- renderTable({
    req(prediction())
    prediction()$neighbors
  }, striped = TRUE, bordered = TRUE, spacing = "s")
}
