dataSourcesUI <- function(id) {
  ns <- NS(id)
  
  tabPanel(
    title = "Data Sources",
    icon = icon("database"),
    uiOutput(ns("data_sources_content"))
  )
}

dataSourcesServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$data_sources_content <- renderUI({
      HTML("
        <div class='container'>
          <h2 class='mt-4 mb-3'>Data Sources Overview</h2>
          <p class='lead'>Our Melbourne Tourism Explorer app integrates multiple data sources to provide comprehensive travel information. These sources have been carefully selected to offer users the most accurate and up-to-date information about Melbourne.</p>
          
          <h3 class='mt-4'>Tableau Public Embedded</h3>
          <div class='card mt-3'>
            <div class='card-body'>
              <p>Our interactive tourism analysis dashboard is created using Tableau Public. The visualization includes:
              <ul>
            <li>Accommodation preferences analysis (2023-2024)</li>
            <li>Transport mode analysis for interstate and intrastate travel</li>
        </ul>
        You can explore the full interactive dashboard here:
        <a href='https://public.tableau.com/app/profile/pengjiabei.tang/viz/melbournetourism/Dashboard1?publish=yes' target='_blank'>
            Melbourne Tourism Analysis Dashboard
        </a>
        <br>
        The VIC tourism data source from Australian Trade and Investment Commission Tourism Research Australia：
        <a href='https://www.tra.gov.au/en/domestic/domestic-tourism-results#ref4' target='_blank'>
            National Visitor Survey results
            </a>
              </p>
            </div>
          </div>
          
          <h3 class='mt-4'>Primary Data Sources</h3>
          <ul class='list-group'>
            <li class='list-group-item'>
              <strong>Interface Design:</strong>
              <ul>
                <li><a href='https://shiny.posit.co/r/gallery/government-public-sector/nz-trade-dash/' target='_blank'>New Zealand Trade Intelligence Dashboard</a></li>
              </ul>
            </li>
            <li class='list-group-item'>
              <strong>Weather Information:</strong>
              <ul>
                <li><a href='https://openweathermap.org/api' target='_blank'>OpenWeatherMap API</a></li>
                <li>Implementation using <a href='https://cran.r-project.org/web/packages/googleAuthR/vignettes/setup.html' target='_blank'>Google Auth R Package Documentation</a></li>
              </ul>
            </li>
            <li class='list-group-item'>
              <strong>Landmarks and Attractions:</strong>
              <ul>
                <li><a href='https://data.melbourne.vic.gov.au/explore/dataset/landmarks-and-places-of-interest-including-schools-theatres-health-services-spor/information/' target='_blank'>Landmarks and places of interest in Melbourne</a></li>
              </ul>
            </li>
            <li class='list-group-item'>
              <strong>Accommodation Data:</strong>
              <ul>
                <li><a href='https://insideairbnb.com/get-the-data/' target='_blank'>Inside Airbnb - Melbourne, Victoria, Australia Dataset</a></li>
              </ul>
            </li>
            <li class='list-group-item'>
              <strong>Restaurant Information:</strong>
              <ul>
                <li><a href='https://data.melbourne.vic.gov.au/explore/dataset/cafes-and-restaurants-with-seating-capacity/information/' target='_blank'>Café, restaurant, bistro seats</a></li>
              </ul>
            </li>
            <li class='list-group-item'>
              <strong>Transportation Data:</strong>
              <ul>
                <li><a href='https://discover.data.vic.gov.au/dataset/ptv-metro-tram-routes' target='_blank'>PTV Metro Tram Routes</a></li>
                <li>Transport Flow: <a href='https://www.ptv.vic.gov.au/footer/data-and-reporting/datasets/' target='_blank'>Victorian public transport data</a></li>
              </ul>
            </li>
          </ul>
  
          
          
        </div>
      ")
    })
  })
}