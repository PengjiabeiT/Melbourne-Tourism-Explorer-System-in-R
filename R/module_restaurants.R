get_data <- function() {
  data <- read_csv("data/restaurants.csv")
  
  data %>%
    rename(
      number_of_seats = `Number of seats`,
      longitude = Longitude,
      latitude = Latitude
    ) %>%
    select(
      `Business address`,
      `CLUE small area`,
      `Trading name`,
      `Industry (ANZSIC4) description`,
      `Seating type`,
      number_of_seats,
      longitude,
      latitude,
      location
    )
}

restaurantsUI <- function(id) {
  ns <- NS(id)
  fluidPage(
    useShinyjs(),
    tags$head(
      tags$style(HTML("
      .map-container { height: 70vh; }
      .filter-container { 
        padding: 15px;
        background-color: #ffffff;
        border-radius: 5px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
      }
      .filter-title {
        font-weight: bold;
        margin-bottom: 10px;
      }
      .table-container { overflow-x: auto; }
      .info-panel { min-height: 200px; }
      .action-button { margin-top: 10px; }
    "))
    ),
    titlePanel("Melbourne Foodie Explorer"),
    
    fluidRow(
      column(9,
             div(class = "map-container", leafletOutput(ns("map"), height = "100%"))
      ),
      column(3,
             wellPanel(
               div(class = "filter-container",
                   h4(class = "filter-title", "Filters"),
                   textInput(ns("search"), "Search restaurants:", ""),
                   selectInput(ns("industry"), "Industry:",
                               choices = c("All", "Cafes and Restaurants", "Takeaway Food Services", "Pubs, Taverns and Bars"),
                               selected = "All"),
                   selectInput(ns("area"), "Area:", choices = c("All"), selected = "All"),
                   actionButton(ns("clear"), "Clear All", class = "btn-primary btn-block")
               )
             )
      )
    ),
    
    br(),
    
    fluidRow(
      column(9,
             div(class = "table-container", DTOutput(ns("restaurant_table")))
      ),
      column(3,
             div(class = "info-panel", uiOutput(ns("info_panel")))
      )
    )
  )
}

restaurantsServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    all_data <- reactiveVal(data.frame())
    
    observe({
      initial_data <- get_data()
      all_data(initial_data)
      
      # Update the options selected by Area
      areas <- c("All", unique(initial_data$`CLUE small area`))
      updateSelectInput(session, "area", choices = areas)
    })
    
    filtered_data <- reactive({
      data <- all_data()
      
      if (input$industry != "All") {
        data <- data %>% filter(`Industry (ANZSIC4) description` == input$industry)
      }
      
      if (input$area != "All") {
        data <- data %>% filter(`CLUE small area` == input$area)
      }
      
      if (nchar(input$search) > 0) {
        data <- data %>% filter(grepl(input$search, `Trading name`, ignore.case = TRUE))
      }
      
      data
    })
    
    output$map <- renderLeaflet({
      leaflet() %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        setView(lng = 144.9631, lat = -37.8136, zoom = 12) %>%
        addScaleBar(position = "bottomleft")
    })
    
    observe({
      data <- filtered_data()
      
      leafletProxy("map", data = data) %>%
        clearMarkers() %>%
        addMarkers(
          ~longitude, ~latitude,
          popup = ~paste0("<b>", `Trading name`, "</b><br>",
                          "Type: ", `Industry (ANZSIC4) description`, "<br>",
                          "Seats: ", number_of_seats, "<br>",
                          "Area: ", `CLUE small area`),
          clusterOptions = markerClusterOptions(
            spiderfyOnMaxZoom = FALSE,
            disableClusteringAtZoom = 16
          )
        )
      
      if(nrow(data) > 0) {
        leafletProxy("map") %>%
          fitBounds(
            min(data$longitude), min(data$latitude),
            max(data$longitude), max(data$latitude)
          )
      }
    })
    
    output$restaurant_table <- renderDT({
      datatable(
        filtered_data() %>% select(`Trading name`, `Industry (ANZSIC4) description`, number_of_seats, `CLUE small area`),
        options = list(pageLength = 5, lengthMenu = c(5, 10, 25)),
        selection = 'single'
      )
    })
    
    output$info_panel <- renderUI({
      selected <- input$restaurant_table_rows_selected
      if (length(selected) == 0) return(NULL)
      
      restaurant <- filtered_data()[selected, ]
      
      # Encode the restaurant name and address for use in URLs
      encoded_name <- URLencode(restaurant$`Trading name`)
      encoded_address <- URLencode(paste(restaurant$`Business address`, "Melbourne, Australia"))
      
      div(
        h3(restaurant$`Trading name`),
        p(paste("Type:", restaurant$`Industry (ANZSIC4) description`)),
        p(paste("Address:", restaurant$`Business address`)),
        p(paste("Seats:", restaurant$number_of_seats, "(", restaurant$`Seating type`, ")")),
        p(paste("Area:", restaurant$`CLUE small area`)),
        a(actionButton(session$ns("Booking"), "Booking", class = "action-button"),
          href = paste0("https://www.google.com/search?q=", encoded_name, "+Melbourne"),
          target = "_blank"),
        a(actionButton(session$ns("Navigation"), "Navigation", class = "action-button"),
          href = paste0("https://www.google.com/maps/search/?api=1&query=", encoded_address),
          target = "_blank")
      )
    })
    
    observe({
      selected <- input$restaurant_table_rows_selected
      if (length(selected) == 0) return()
      
      restaurant <- filtered_data()[selected, ]
      leafletProxy("map") %>%
        setView(lng = restaurant$longitude, lat = restaurant$latitude, zoom = 15) %>%
        clearMarkers() %>%
        addMarkers(
          lng = restaurant$longitude, lat = restaurant$latitude,
          popup = paste0("<b>", restaurant$`Trading name`, "</b><br>",
                         "Type: ", restaurant$`Industry (ANZSIC4) description`, "<br>",
                         "Seats: ", restaurant$number_of_seats, "<br>",
                         "Area: ", restaurant$`CLUE small area`)
        )
    })
    
    observeEvent(input$search, {
      data <- filtered_data()
      if (nrow(data) > 0) {
        leafletProxy("map") %>%
          fitBounds(
            min(data$longitude), min(data$latitude),
            max(data$longitude), max(data$latitude)
          )
      }
    })
    
    #Clear all functions
    observeEvent(input$clear, {
      # Reset all inputs
      updateTextInput(session, "search", value = "")
      updateSelectInput(session, "industry", selected = "All")
      updateSelectInput(session, "area", selected = "All")
      
      # Reset the map
      leafletProxy("map") %>%
        clearMarkers() %>%
        setView(lng = 144.9631, lat = -37.8136, zoom = 12)
      
      # Reset the table selection
      dataTableProxy("restaurant_table") %>%
        selectRows(NULL)
      
      # Refresh data
      all_data(get_data())
    })
  })
}