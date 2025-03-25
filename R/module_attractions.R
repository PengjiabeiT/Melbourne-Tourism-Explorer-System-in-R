
# Load and process data
load_and_process_attractions <- function() {
  landmarks <- read.csv("data/landmarks_with_lat_long.csv")
  landmarks %>%
    mutate(Region = case_when(
      Latitude >= -37.820 & Latitude <= -37.800 & Longitude >= 144.950 & Longitude <= 144.975 ~ "CBD",
      Longitude < 144.950 ~ "West Region",
      Longitude > 144.975 ~ "East Region",
      Latitude > -37.800 ~ "North Region",
      Latitude < -37.820 ~ "South Region",
      TRUE ~ "Other"
    ))
}

# UI function
attractionsUI <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    # Title with custom styling
    div(
      class = "page-title",
      style = "
        margin-bottom: 20px;
        padding: 15px 0;
        border-bottom: 1px solid #eee;
      ",
      h2("Melbourne Attractions Map", 
         style = "margin: 0; color: #4A4737;")
    ),
    
    # Main content using fluidRow and columns
    fluidRow(
      # Map panel (wider)
      column(
        width = 9,
        div(
          class = "map-container",
          style = "
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 15px;
            height: calc(100vh - 150px);
          ",
          leafletOutput(ns("attractionsMap"), height = "100%")
        )
      ),
      
      # Filters panel (narrower)
      column(
        width = 3,
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
          h4("Filter Attractions", 
             style = "
               margin-top: 0;
               margin-bottom: 20px;
               color: #4A4737;
               border-bottom: 2px solid #E7E3DE;
               padding-bottom: 10px;
             "),
          
          # Filter inputs with consistent styling
          div(
            class = "filter-group",
            style = "margin-bottom: 20px;",
            
            selectInput(
              ns("region"), 
              "Select Region",
              choices = c("All", "CBD", "West Region", "East Region", 
                          "North Region", "South Region", "Other"),
              selected = "All",
              width = "100%"
            )
          ),
          
          div(
            class = "filter-group",
            style = "margin-bottom: 20px;",
            
            selectInput(
              ns("theme"), 
              "Select Theme",
              choices = "All",
              selected = "All",
              width = "100%"
            )
          ),
          
          div(
            class = "filter-group",
            style = "margin-bottom: 20px;",
            
            selectInput(
              ns("subTheme"), 
              "Select Sub Theme",
              choices = "All",
              selected = "All",
              width = "100%"
            )
          ),
          
          div(
            class = "filter-group",
            style = "margin-bottom: 20px;",
            
            selectInput(
              ns("mapStyle"), 
              "Select Map Style",
              choices = c(
                "Light" = "CartoDB.Positron", 
                "Dark" = "CartoDB.DarkMatter"
              ),
              selected = "CartoDB.Positron",
              width = "100%"
            )
          )
        )
      )
    )
  )
}

# Server function
attractionsServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    attractions <- load_and_process_attractions()
    
    # Update theme choices
    observe({
      updateSelectInput(session, "theme", choices = c("All", unique(attractions$Theme)))
    })
    
    # Update sub-theme choices based on selected theme
    observeEvent(input$theme, {
      if (input$theme == "All") {
        updateSelectInput(session, "subTheme", choices = "All", selected = "All")
      } else {
        subThemes <- unique(attractions$Sub.Theme[attractions$Theme == input$theme])
        updateSelectInput(session, "subTheme", choices = c("All", subThemes))
      }
    })
    
    # Filter data based on user input
    filteredData <- reactive({
      data <- attractions
      if (input$region != "All") {
        data <- data %>% filter(Region == input$region)
      }
      if (input$theme != "All") {
        data <- data %>% filter(Theme == input$theme)
      }
      if (input$subTheme != "All") {
        data <- data %>% filter(Sub.Theme == input$subTheme)
      }
      return(data)
    })
    
    # Custom icon function
    getIcon <- function(theme) {
      awesomeIcons(
        icon = case_when(
          theme == "Place of Worship" ~ "map-marker",
          theme == "Transport" ~ "bus",
          theme == "Leisure/Recreation" ~ "flag",
          theme == "Education Centre" ~ "graduation-cap",
          theme == "Place Of Assembly" ~ "users",
          theme == "Mixed Use" ~ "building",
          theme == "Health Services" ~ "medkit",
          theme == "Community Use" ~ "users",
          theme == "Vacant Land" ~ "tree",
          theme == "Office" ~ "briefcase",
          theme == "Residential Accommodation" ~ "home",
          theme == "Retail" ~ "shopping-cart",
          theme == "Industrial" ~ "cog",
          TRUE ~ "map-marker"
        ),
        iconColor = "white",
        markerColor = case_when(
          theme == "Place of Worship" ~ "blue",
          theme == "Transport" ~ "orange",
          theme == "Leisure/Recreation" ~ "purple",
          theme == "Education Centre" ~ "green",
          theme == "Place Of Assembly" ~ "red",
          theme == "Mixed Use" ~ "cyan",
          theme == "Health Services" ~ "pink",
          theme == "Community Use" ~ "yellow",
          theme == "Vacant Land" ~ "green",
          theme == "Office" ~ "gray",
          theme == "Residential Accommodation" ~ "purple",
          theme == "Retail" ~ "coral",
          theme == "Industrial" ~ "lime",
          TRUE ~ "gray"
        ),
        library = "fa"
      )
    }
    
    # Render leaflet map
    output$attractionsMap <- renderLeaflet({
      data <- filteredData()
      mapStyle <- input$mapStyle
      
      if (nrow(data) == 0) {
        leaflet() %>%
          addProviderTiles(providers[[mapStyle]]) %>%
          setView(lng = 144.9631, lat = -37.8136, zoom = 12)
      } else {
        leaflet(data) %>%
          addProviderTiles(providers[[mapStyle]]) %>%
          addAwesomeMarkers(lat = ~Latitude, lng = ~Longitude,
                            label = ~Feature.Name,
                            popup = ~paste("<b>Feature:</b>", Feature.Name, "<br/>",
                                           "<b>Theme:</b>", Theme, "<br/>",
                                           "<b>Sub Theme:</b>", Sub.Theme),
                            icon = ~getIcon(Theme),
                            clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = TRUE)) %>%
          addHeatmap(lng = ~Longitude, lat = ~Latitude, blur = 20, max = 0.05, radius = 15)
      }
    })
  })
}