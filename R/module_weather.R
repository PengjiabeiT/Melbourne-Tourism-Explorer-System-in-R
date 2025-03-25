# Set API key and base URL
api_key <- "a168ac4157dd988ca05ae9b99640bd48"
base_url_forecast <- "http://api.openweathermap.org/data/2.5/forecast"

# Function to get the 5-day/3-hour forecast data
get_forecast_info <- function() {
  url <- paste0(base_url_forecast, 
                "?lat=-37.8136&lon=144.9631&appid=", api_key, "&units=metric")
  response <- httr::GET(url)
  forecast_data <- httr::content(response, "parsed", encoding = "UTF-8")
  return(forecast_data)
}

# Parse API response into a data frame
process_forecast_data <- function(forecast_data) {
  forecast_list <- forecast_data$list
  
  # Create a data frame extracting relevant weather info for each time period
  df <- data.frame(
    Time = sapply(forecast_list, function(x) {
      # Convert Unix timestamp to readable datetime format, without format()
      as.POSIXct(x$dt, origin = "1970-01-01", tz = "Australia/Melbourne")
    }),
    Temperature = sapply(forecast_list, function(x) x$main$temp),
    Feels_Like = sapply(forecast_list, function(x) x$main$feels_like),
    Weather = sapply(forecast_list, function(x) x$weather[[1]]$description),
    Wind_Speed = sapply(forecast_list, function(x) x$wind$speed),
    Visibility = sapply(forecast_list, function(x) x$visibility),
    stringsAsFactors = FALSE
  )
  
  # Add a date column for grouping
  df$Time <- as.POSIXct(df$Time, origin = "1970-01-01", tz = "Australia/Melbourne")
  df$Date <- as.Date(df$Time)
  
  return(df)
}

process_forecast_data_lineChart <- function(forecast_data) {
  forecast_list <- forecast_data$list
  
  # Create a data frame extracting relevant weather info for each time period
  df <- data.frame(
    Time = sapply(forecast_list, function(x) {
      as.POSIXct(x$dt, origin = "1970-01-01", tz = "Australia/Melbourne")
    }),
    Temperature = sapply(forecast_list, function(x) x$main$temp),
    stringsAsFactors = FALSE
  )
  
  # Ensure Time column is POSIXct type
  df$Time <- as.POSIXct(df$Time, origin = "1970-01-01", tz = "Australia/Melbourne")
  
  return(df)
}

# UI function
weatherUI <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    tags$head(
      tags$style(HTML("
    .weather-icon-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      margin-bottom: 25px;
    }
    
    .weather-icon-large {
      width: 150px; 
      height: 150px; 
      object-fit: contain;
      margin-bottom: 15px;
      transition: transform 0.3s ease;
    }
    
    .weather-icon-large:hover {
      transform: scale(1.05);
    }
    
    .weather-details {
      font-size: 1.1em;
      color: #4A4737;
      width: 100%;
      padding: 0 10px;
    }
    
    .weather-details p {
      margin: 12px 0;
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 8px;
      background: #f8f9fa;
      border-radius: 6px;
      transition: background-color 0.2s;
    }
    
    .weather-details p:hover {
      background: #e9ecef;
    }
    
    .weather-details i {
      width: 20px;
      color: #6B7F76;
    }
    
    .weather-details strong {
      margin-left: auto;
      color: #4A4737;
    }
  "))
    ),
    # Title section
    div(
      class = "page-title",
      style = "
        margin-bottom: 20px;
        padding: 15px 0;
        border-bottom: 1px solid #eee;
      ",
      h2("Melbourne Weather Forecast", 
         style = "margin: 0; color: #4A4737;")
    ),
    
    # First row: Current Weather and 5-Day Forecast
    fluidRow(
      # Current Weather Card
      column(
        width = 4,
        div(
          class = "weather-card",
          style = "
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
            height: 550px;
          ",
          h3("Current Weather", 
             style = "
               margin-top: 0;
               margin-bottom: 20px;
               color: #4A4737;
               border-bottom: 2px solid #E7E3DE;
               padding-bottom: 10px;
             "),
          uiOutput(ns("current_weather"))
        )
      ),
      
      # 5-Day Forecast Card
      column(
        width = 8,
        div(
          class = "forecast-card",
          style = "
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
            height: 550px;
          ",
          h3("5-Day Temperature Forecast", 
             style = "
               margin-top: 0;
               margin-bottom: 20px;
               color: #4A4737;
               border-bottom: 2px solid #E7E3DE;
               padding-bottom: 10px;
             "),
          plotlyOutput(ns("temperature_plot"), height = "320px")
        )
      )
    ),
    
    # Second row: Detailed Forecast Table
    fluidRow(
      column(
        width = 12,
        div(
          class = "detail-forecast-card",
          style = "
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
          ",
          # Header with title and date selector
          div(
            style = "
              display: flex;
              justify-content: space-between;
              align-items: center;
              margin-bottom: 20px;
              border-bottom: 2px solid #E7E3DE;
              padding-bottom: 10px;
            ",
            h3("3-Hour Detailed Forecast", 
               style = "margin: 0; color: #4A4737;"),
            div(
              style = "min-width: 200px;",
              selectInput(
                ns("date_selector"), 
                "Choose Date:", 
                choices = NULL, 
                width = "100%"
              )
            )
          ),
          # Forecast table
          DTOutput(ns("forecast_table"))
        )
      )
    )
  )
}



# Server function
weatherServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Get forecast data
    forecast_data <- reactive({
      get_forecast_info()
    })
    
    # Process forecast data for table
    forecast_df <- reactive({
      process_forecast_data(forecast_data())
    })
    
    # Process forecast data for line chart
    forecast_df_lineChart <- reactive({
      process_forecast_data_lineChart(forecast_data())
    })
    
    # Update date selector choices
    observe({
      dates <- unique(forecast_df()$Date)
      updateSelectInput(session, "date_selector", 
                        choices = dates,
                        selected = dates[1])
    })
    
    # Filter data based on selected date
    filtered_data <- reactive({
      req(input$date_selector)
      df <- forecast_df()
      df[df$Date == as.Date(input$date_selector), ]
    })
    
    # Render current weather information
    output$current_weather <- renderUI({
      current_data <- forecast_data()$list[[1]]
      
      weather_type <- current_data$weather[[1]]$main
      temperature <- current_data$main$temp
      feels_like <- current_data$main$feels_like
      wind_speed <- current_data$wind$speed
      visibility <- current_data$visibility
      
      # Determine weather icon based on conditions
      icon_path <- switch(weather_type,
                          "Rain" = "images/rainy.png",
                          "Clear" = "images/clear.png",
                          "Clouds" = "images/cloudy.png",
                          "images/error.png")
      
      tagList(
        div(class = "weather-icon-container",
            img(src = icon_path,
                class = "weather-icon-large",
                alt = paste("Weather:", weather_type)),
            h3(weather_type,
               style = "margin: 0; color: #4A4737; font-size: 1.5em;")
        ),
        div(class = "weather-details",
            p(
              icon("thermometer-half"), 
              "Temperature",
              strong(paste(round(temperature, 1), "°C"))
            ),
            p(
              icon("temperature-low"), 
              "Feels Like",
              strong(paste(round(feels_like, 1), "°C"))
            ),
            p(
              icon("wind"), 
              "Wind Speed",
              strong(paste(wind_speed, "m/s"))
            ),
            p(
              icon("eye"), 
              "Visibility",
              strong(paste(format(visibility, big.mark = ","), "m"))
            )
        )
      )
    })
    
    # Render forecast table
    output$forecast_table <- renderDT({
      df <- filtered_data()
      datatable(
        df[, c("Time", "Temperature", "Weather", "Wind_Speed", "Visibility")],
        options = list(
          pageLength = 8,
          lengthMenu = c(8, 16, 24),
          searching = FALSE,
          info = FALSE,
          lengthChange = FALSE,
          dom = 't',
          columnDefs = list(
            list(className = 'dt-center', targets = '_all')
          )
        ),
        rownames = FALSE,
        class = 'cell-border stripe'
      ) %>%
        formatStyle(
          'Weather',
          backgroundColor = styleEqual(
            c("clear sky", "scattered clouds", "light rain"),
            c("#F9F5E9", "#E7E3DE", "#E1E8ED")
          ),
          color = styleEqual(
            c("clear sky", "scattered clouds", "light rain"),
            c("#4A4737", "#4A4737", "#4A4737")
          )
        )
    })
    
    # Render temperature plot
    output$temperature_plot <- renderPlotly({
      p <- ggplot(forecast_df_lineChart(), aes(x = Time, y = Temperature)) +
        geom_line(color = "#6B7F76", size = 1.2) +
        geom_point(color = "#4A4737", size = 3) +
        labs(x = "Date", y = "Temperature (°C)") +
        theme_minimal() +
        scale_x_datetime(date_breaks = "1 day", date_labels = "%b %d") +
        theme(
          panel.background = element_rect(fill = "white", color = NA),
          plot.background = element_rect(fill = "white", color = NA),
          panel.grid.major = element_line(color = "#E7E3DE"),
          panel.grid.minor = element_blank(),
          plot.title = element_text(color = "#4A4737", size = 16, face = "bold"),
          axis.title = element_text(color = "#4A4737", size = 12),
          axis.text = element_text(color = "#6B7F76")
        )
      
      ggplotly(p, tooltip = c("x", "y")) %>%
        layout(
          hovermode = "x unified",
          paper_bgcolor = "white",
          plot_bgcolor = "white"
        )
    })
  })
}