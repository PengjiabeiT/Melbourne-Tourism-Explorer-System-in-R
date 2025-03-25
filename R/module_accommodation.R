
# Data preprocessing
load_and_process_data <- function() {
  data <- read_csv("data/Melbourne airbnb listing.csv")
  data %>%
    filter(!is.na(price)) %>%
    mutate(price_level = case_when(
      price <= quantile(price, 0.33) ~ "Cheap",
      price > quantile(price, 0.33) & price <= quantile(price, 0.66) ~ "Medium",
      TRUE ~ "Expensive"
    ))
}

# UI function
accommodationUI <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    # Title section
    div(
      class = "page-title",
      style = "
        margin-bottom: 20px;
        padding: 15px 0;
        border-bottom: 1px solid #eee;
      ",
      h2("Melbourne Accommodation", 
         style = "margin: 0; color: #4A4737;")
    ),
    
    # Main content
    fluidRow(
      # Map panel (wider)
      column(
        width = 8,
        div(
          class = "map-container",
          style = "
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 15px;
            height: calc(100vh - 150px);
          ",
          leafletOutput(ns("map"), height = "100%")
        )
      ),
      
      # Filters panel (narrower)
      column(
        width = 4,
        div(
          class = "filters-container",
          style = "
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            height: calc(100vh - 150px);
            overflow-y: auto;
          ",
          
          # Filter title
          h4("Accommodation Filters", 
             style = "
               margin-top: 0;
               margin-bottom: 20px;
               color: #4A4737;
               border-bottom: 2px solid #E7E3DE;
               padding-bottom: 10px;
             "),
          
          # Filter inputs
          div(
            class = "filter-group",
            style = "margin-bottom: 20px;",
            
            pickerInput(
              inputId = ns("neighbourhood"), 
              label = "Select neighbourhood:", 
              choices = NULL,  
              options = list(
                `actions-box` = TRUE,
                size = 5
              ), 
              multiple = TRUE,
              width = "100%"
            )
          ),
          
          div(
            class = "filter-group",
            style = "margin-bottom: 20px;",
            
            sliderInput(
              ns("priceRange"), 
              "Select price (per night) range:", 
              min = 0, 
              max = 1000, 
              value = c(0, 1000),
              width = "100%"
            )
          ),
          
          div(
            class = "filter-group",
            style = "margin-bottom: 20px;",
            
            checkboxGroupInput(
              ns("priceClass"), 
              "Select price class:", 
              choices = c("Cheap", "Medium", "Expensive"), 
              selected = c("Cheap", "Medium", "Expensive")
            )
          ),
          
          # Distribution Chart
          div(
            class = "chart-container",
            style = "
              margin-top: 30px;
              padding-top: 20px;
              border-top: 1px solid #E7E3DE;
            ",
            h4("Price Distribution", 
               style = "
                 margin-top: 0;
                 margin-bottom: 15px;
                 color: #4A4737;
               "),
            plotlyOutput(ns("pie_chart"), height = "260px")
          )
        )
      )
    )
  )
}

# Server function
accommodationServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    data <- load_and_process_data()
    
    observe({
      updatePickerInput(session, "neighbourhood", choices = unique(data$neighbourhood), selected = unique(data$neighbourhood))
    })
    
    observe({
      updateSliderInput(session, "priceRange", min = min(data$price), max = max(data$price), value = c(min(data$price), max(data$price)))
    })
    
    filteredData <- reactive({
      data %>%
        filter(neighbourhood %in% input$neighbourhood, 
               price >= input$priceRange[1], price <= input$priceRange[2],
               price_level %in% input$priceClass)
    })
    
    output$map <- renderLeaflet({
      filtered <- filteredData()
      
      if (nrow(filtered) == 0) {
        leaflet() %>% addTiles()
      } else {
        leaflet(filtered) %>%
          addTiles() %>%
          addMarkers(
            lng = ~longitude, lat = ~latitude, 
            popup = ~paste("<b>Price:</b>", price, "<br><b>Price Level:</b>", price_level),
            clusterOptions = markerClusterOptions()
          ) %>%
          setView(lng = mean(filtered$longitude, na.rm = TRUE), 
                  lat = mean(filtered$latitude, na.rm = TRUE), 
                  zoom = 12)
      }
    })
    
    output$pie_chart <- renderPlotly({
      filtered <- filteredData()
      
      if (nrow(filtered) == 0) {
        return(NULL)
      } else {
        plot_ly(
          filtered, 
          labels = ~room_type, 
          values = ~price, 
          type = 'pie',
          textinfo = 'label+percent',
          insidetextorientation = 'horizontal',
          marker = list(
            colors = c('#A1D6E2', '#1995AD', '#1E656D', '#66A5AD', '#B3CDE0'),
            line = list(color = '#FFFFFF', width = 1)
          )
        ) %>%
          layout(
            title = list(text = "Distribution of Room Types", y = 0.95),
            showlegend = TRUE,
            legend = list(orientation = "h", x = 0.3, y = -0.2),
            margin = list(l = -40, r = 80, t = 120, b = 40) 
          )
      }
    })
  })
}