overviewUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Hero Section
    fluidRow(
      column(
        width = 12,
        div(
          class = "hero-section",
          style = paste0(
            "position: relative;",
            "height: 300px;",
            "background: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)), ",
            "url('images/melb.jpg');",
            "background-size: cover;",
            "background-position: center;",
            "border-radius: 8px;",
            "margin-bottom: 20px;",
            "margin-top: 20px;"
          ),
          div(
            style = paste0(
              "position: absolute;",
              "top: 50%;",
              "left: 50%;",
              "transform: translate(-50%, -50%);",
              "text-align: center;",
              "color: white;",
              "width: 100%;",
              "padding: 0 20px;"
            ),
            h1(
              "Welcome to Melbourne", 
              style = "font-size: 5em; margin-bottom: 15px; font-weight: bold;"
            ),
            p(
              "Discover the world's most liveable city", 
              style = "font-size: 2.5em; margin: 0;"
            )
          )
        )
      )
    ),
    
    # Quick Stats Section
    fluidRow(
      # Weather Card
      column(
        width = 4,
        div(
          class = "stat-card",
          style = "
        background: #E7E3DE;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        margin-bottom: 20px;
        height: 120px;
        display: flex;
        align-items: center;
      ",
          div(
            style = "display: flex; align-items: center; gap: 15px; width: 100%;",
            uiOutput(ns("weather_icon")),
            div(
              style = "flex-grow: 1;",
              h4("Current Weather", style = "margin: 0 0 8px 0; color: #4A4737;"),
              textOutput(ns("weather_info"))  
            )
          )
        )
      ),
      
      # Time Card
      column(
        width = 4,
        div(
          class = "stat-card",
          style = "
        background: #D8E2DC;  
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        margin-bottom: 20px;
        height: 120px;
        display: flex;
        align-items: center;
      ",
          div(
            style = "display: flex; align-items: center; gap: 15px; width: 100%;",
            icon("clock", "fa-2x", style = "color: #6B7F76; margin-left: 20px;"), 
            div(
              style = "flex-grow: 1;",
              h4("Local Time", style = "margin: 0 0 8px 0; color: #4A4737;"),
              textOutput(ns("current_time"))
            )
          )
        )
      ),
      
      # Visitor Stats Card
      column(
        width = 4,
        div(
          class = "stat-card",
          style = "
        background: #E3D5CA; 
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        margin-bottom: 20px;
        height: 120px;
        display: flex;
        align-items: center;
      ",
          div(
            style = "display: flex; align-items: center; gap: 15px; width: 100%;",
            icon("users", "fa-2x", style = "color: #9D8176;margin-left: 20px;"),
            div(
              style = "flex-grow: 1;",
              h4("Annual Visitors to Melbourne", style = "margin: 0 0 8px 0; color: #4A4737;"),
              p(
                style = "margin: 0; font-size: 1.1em; font-weight: bold; color: #4A4737;",
                "10.3M"
              ),
              p(
                style = "margin: 0; font-size: 0.9em; color: #6B7F76;",
                span(
                  icon("arrow-up"), 
                  "+4.8% from last year"
                )
              )
            )
          )
        )
      )
    ),
    

    
    # Tableau Dashboard Section
    fluidRow(
      column(12,
             div(
               class = "dashboard-section",
               style = "background: #F8F9FA; padding: 20px; border-radius: 8px; margin: 20px 0;",
               
               # Title and description
               div(
                 class = "section-intro",
                 style = "margin-bottom: 20px;",
                 h3("Tourism Insights", 
                    class = "section-header",
                    style = "color: #4A4737; font-size: 1.8em; margin-bottom: 10px;"
                 ),
                 p("Analysis of accommodation preferences and transport patterns in Victoria",
                   style = "color: #6B7F76; font-size: 1.1em;"
                 )
               ),
               
               # Tableau Container
               div(
                 class = "tableau-dashboard-container",
                 style = "background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 15px; margin-top: 10px;",
                 HTML('
          <div class="tableauPlaceholder" id="viz1729667414942" style="position: relative">
            <noscript>
              <a href="#">
                <img alt="Dashboard 1" 
                     src="https://public.tableau.com/static/images/me/melbournetourism/Dashboard1/1_rss.png" 
                     style="border: none" />
              </a>
            </noscript>
            <object class="tableauViz" style="display:none;">
              <param name="host_url" value="https%3A%2F%2Fpublic.tableau.com%2F" />
              <param name="embed_code_version" value="3" />
              <param name="site_root" value="" />
              <param name="name" value="melbournetourism/Dashboard1" />
              <param name="tabs" value="no" />
              <param name="toolbar" value="yes" />
              <param name="static_image" value="https://public.tableau.com/static/images/me/melbournetourism/Dashboard1/1.png" />
              <param name="animate_transition" value="yes" />
              <param name="display_static_image" value="yes" />
              <param name="display_spinner" value="yes" />
              <param name="display_overlay" value="yes" />
              <param name="display_count" value="yes" />
              <param name="language" value="en-GB" />
              <param name="filter" value="publish=yes" />
            </object>
          </div>
        '),
                 tags$script(HTML('
          document.addEventListener("DOMContentLoaded", function() {
            var divElement = document.getElementById("viz1729667414942");
            var vizElement = divElement.getElementsByTagName("object")[0];
            vizElement.style.width = "100%";
            vizElement.style.height = "700px";  
            var scriptElement = document.createElement("script");
            scriptElement.src = "https://public.tableau.com/javascripts/api/viz_v1.js";
            vizElement.parentNode.insertBefore(scriptElement, vizElement);
          });
        '))
               ),
               
               # Add a brief description
               div(
                 class = "dashboard-footer",
                 style = "margin-top: 15px; padding-top: 15px; border-top: 1px solid #E7E3DE;",
                 div(
                   class = "row",
                   div(
                     class = "col-md-6",
                     p(
                       icon("info-circle", class = "mr-2"),
                       "Data source: Tourism Research Australia",
                       style = "color: #6B7F76; font-size: 0.9em;"
                     )
                   ),
                   div(
                     class = "col-md-6 text-right",
                     p(
                       "Updated: October 2024",
                       style = "color: #6B7F76; font-size: 0.9em;"
                     )
                   )
                 )
               )
             )
      )
    ),
             
    # Public Transport Analysis Section
    fluidRow(
      column(12,
             h3("Public Transport Analysis:", class = "section-header"),
             div(class = "analysis-container",
                 fluidRow(
                   # Left column for image
                   column(7,
                          img(src = "images/Melbourne Public Transport.jpg",
                              width = "100%",
                              height = "auto",
                              alt = "Melbourne Public Transport Analysis",
                              class = "transport-analysis-img"
                          )
                   ),
                   # Right column for bullet points
                   column(5,
                          div(class = "analysis-points",
                              tags$ul(
                                tags$li(
                                  strong("Peak Usage Pattern: "), 
                                  "MetroTrain and Tram services show highest usage during weekday business hours, particularly Thursday and Friday"
                                ),
                                tags$li(
                                  strong("Weekend Transit: "), 
                                  "Regional services maintain consistent lower volume across weekends, while metro services show moderate usage"
                                )
                              )
                          )
                   )
                 )
             )
      )
    )
    )
}

# Server function
overviewServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Current weather output
    forecast_data <- reactive({
      get_forecast_info()
    })
    
    # Render the weather icon
    output$weather_icon <- renderUI({
      req(forecast_data())
      current_data <- forecast_data()$list[[1]]
      weather_type <- current_data$weather[[1]]$main
      
      # Choose the appropriate Font Awesome icon according to the weather type
      icon_class <- switch(
        weather_type,
        "Clear" = "sun",
        "Clouds" = "cloud",
        "Rain" = "cloud-rain",
        "Snow" = "snowflake",
        "Thunderstorm" = "bolt",
        "Drizzle" = "cloud-rain",
        "Mist" = "smog",
        "Fog" = "smog",
        "sun"
      )
      
      # Judge whether to use the moon icon according to the time
      hour <- as.numeric(format(Sys.time(), "%H"))
      if(weather_type == "Clear" && (hour < 6 || hour > 18)) {
        icon_class <- "moon"
      }
      
      # Define the color of the icon
      icon_color <- switch(
        weather_type,
        "Clear" = "#F6C101",
        "Clouds" = "#8E9BA2",
        "Rain" = "#4B8BC8", 
        "Snow" = "#B8D4E3", 
        "Thunderstorm" = "#616669",
        "Drizzle" = "#81A8C2", 
        "Mist" = "#9DA5AB", 
        "Fog" = "#A4AAB0", 
        "#F6C101"
      )
      
      icon(icon_class, "fa-2x", style = sprintf("color: %s;", icon_color))
    })
    
    # Render weather information
    output$weather_info <- renderText({
      req(forecast_data())
      current_data <- forecast_data()$list[[1]]
      
      temperature <- current_data$main$temp
      weather_desc <- current_data$weather[[1]]$description
      
      # Capitalize the first letter
      weather_desc <- tools::toTitleCase(weather_desc)
      
      sprintf("%.1f°C\n%s", temperature, weather_desc)
    })
    
    # Current time output
    output$current_time <- renderText({
      invalidateLater(1000)# Update per second
      format(Sys.time(), "%H:%M:%S")
    })
    
  })
}