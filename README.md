# Iris Predictor — Shiny Project

## Description
**Iris Predictor** is a simple Shiny application that helps the user predict the species of a flower from the built-in `iris` dataset based on four measurements:

- sepal length
- sepal width
- petal length
- petal width

The application uses a **k-nearest neighbors (k-NN)** classifier and returns:

- the predicted species
- an estimated confidence value
- a reactive plot
- the 5 most similar flowers from the dataset

## Requirements
Install these R packages:

```r
install.packages(c("shiny", "bslib", "ggplot2", "class"))
```

## Project structure

- `ui.R` → user interface
- `server.R` → server logic and reactive calculations
- `iris_app_presentation.Rpres` → 5-slide presentation in RStudio Presenter
- `README.md` → technical documentation and deployment instructions

## Run locally
In RStudio or the R console, move to the project folder and run:

```r
shiny::runApp()
```

## How this project meets the assignment requirements
- **User input**: sliders, radio buttons, checkbox, action button
- **Server-side processing**: data standardization, k-NN classification, distance computation
- **Reactive output**: text, plot, and table
- **Documentation for inexperienced users**: included in the **"How to use"** tab of the app
- **Code shareable on GitHub**: `ui.R` and `server.R`
- **HTML5 presentation**: `.Rpres` file ready to publish on RPubs or GitHub

## Deploy to shinyapps.io
Example deployment from R:

```r
install.packages("rsconnect")
library(rsconnect)

# Paste here the setAccountInfo command copied from the shinyapps.io Tokens panel
# rsconnect::setAccountInfo(name='ACCOUNT', token='TOKEN', secret='SECRET')

rsconnect::deployApp(appDir = getwd(), appName = "iris-predictor")
```

## Publish the presentation
### Recommended option: RPubs
1. Open `iris_app_presentation.Rpres` in RStudio.
2. Click **Preview**.
3. Select **Publish** and choose **RPubs**.

### Alternative option: GitHub
1. Export the presentation as HTML.
2. Upload the HTML file to your GitHub repository.
3. (Optional) Enable GitHub Pages.

## Suggested GitHub repository structure

```text
iris-predictor/
├── ui.R
├── server.R
├── README.md
└── iris_app_presentation.Rpres
```

## Short submission text
You can use this description:

> I created a Shiny app called **Iris Predictor** that uses the built-in `iris` dataset and a k-NN classifier to predict the species of a flower from four measurements. The app includes user inputs, server-side processing, reactive outputs, and integrated guidance for first-time users. I also prepared a 5-slide HTML5 presentation in **RStudio Presenter** with embedded R code.
