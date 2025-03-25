# module_transport.R

transportUI <- function(id) {
  ns <- NS(id)
  
  # Read data (used when UI is initialized)
  initial_data <- read.csv('data/Melbourne transport dataset.csv') %>%
    separate_rows(ROUTEUSSP, sep = ",") %>%
    distinct(ROUTEUSSP, STOP_NAME, LONGITUDE, LATITUDE)
  
  fluidPage(
    # Title section
    div(
      class = "page-title",
      style = "
        margin-bottom: 20px;
        padding: 15px 0;
        border-bottom: 1px solid #eee;
      ",
      h2("Melbourne Transport Routes",
         style = "margin: 0; color: #4A4737;")
    ),
    
    # Main content
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
          leafletOutput(ns("map"), height = "100%")
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
          h4("Route Filters",
             style = "
               margin-top: 0;
               margin-bottom: 20px;
               color: #4A4737;
               border-bottom: 2px solid #E7E3DE;
               padding-bottom: 10px;
             "),
          
          # Select/Deselect buttons
          div(
            class = "button-group",
            style = "
              display: flex;
              gap: 10px;
              margin-bottom: 20px;
            ",
            actionButton(
              ns("select_all"), 
              "Select All",
              class = "btn-primary",
              style = "
                flex: 1;
                background-color: #4A4737;
                border-color: #4A4737;
                color: white;
                padding: 8px 15px;
                border-radius: 4px;
              "
            ),
            actionButton(
              ns("deselect_all"), 
              "Deselect All",
              class = "btn-secondary",
              style = "
                flex: 1;
                background-color: #E7E3DE;
                border-color: #E7E3DE;
                color: #4A4737;
                padding: 8px 15px;
                border-radius: 4px;
              "
            )
          ),
          
          # Routes checkboxes
          div(
            class = "routes-container",
            style = "
              max-height: calc(100% - 120px);
              overflow-y: auto;
              padding-right: 10px;
            ",
            checkboxGroupInput(
              ns("routes"), 
              "Select Routes:",
              choices = unique(initial_data$ROUTEUSSP),
              selected = unique(initial_data$ROUTEUSSP)
            )
          )
        )
      )
    )
  )
}

transportServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Load and process data reactively
    data <- reactive({
      req(file.exists('data/Melbourne transport dataset.csv'))
      read.csv('data/Melbourne transport dataset.csv')
    })
    
    data_clean <- reactive({
      data() %>%
        separate_rows(ROUTEUSSP, sep = ",") %>%
        distinct(ROUTEUSSP, STOP_NAME, LONGITUDE, LATITUDE)
    })
    
    route_colors <- reactive({
      colorFactor(
        palette = colorRampPalette(brewer.pal(12, "Set3"))(length(unique(data_clean()$ROUTEUSSP))),
        domain = data_clean()$ROUTEUSSP
      )
    })
    
    # Handle "Select All" button click
    observeEvent(input$select_all, {
      updateCheckboxGroupInput(session, "routes",
                               choices = unique(data_clean()$ROUTEUSSP),
                               selected = unique(data_clean()$ROUTEUSSP))
    })
    
    # Handle "Deselect All" button click
    observeEvent(input$deselect_all, {
      updateCheckboxGroupInput(session, "routes",
                               choices = unique(data_clean()$ROUTEUSSP),
                               selected = NULL)
    })
    
    # Filter data based on selected routes
    filteredData <- reactive({
      req(data_clean(), input$routes)
      if (length(input$routes) == 0) {
        data_clean()
      } else {
        data_clean() %>% 
          filter(ROUTEUSSP %in% input$routes)
      }
    })
    
    # Render initial map
    output$map <- renderLeaflet({
      leaflet() %>%
        setView(lng = 144.9631, lat = -37.8136, zoom = 11) %>%
        addProviderTiles(providers$CartoDB.Positron)
    })
    
    # Update map markers
    observe({
      req(filteredData())
      leafletProxy("map", data = filteredData()) %>%
        clearMarkers() %>%
        addCircleMarkers(
          lng = ~LONGITUDE, lat = ~LATITUDE,
          color = ~route_colors()(ROUTEUSSP),
          radius = 4, fillOpacity = 0.8, stroke = FALSE,
          popup = ~paste("<strong>Route:</strong> ", ROUTEUSSP, "<br>",
                         "<strong>Stop Name:</strong> ", STOP_NAME)
        )
    })
  })
}