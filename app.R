source("global.R")

ui <- dashboardPage(
  dashboardHeader(title = "Melbourne Tourism Explorer"),
  dashboardSidebar(
    sidebarMenu(
      id = "sidebarID",
      menuItem("Dashboard", tabName = "overview", icon = icon("dashboard")),
      menuItem("Attractions", tabName = "attractions", icon = icon("landmark")),
      menuItem("Restaurants", tabName = "restaurants", icon = icon("utensils")),
      menuItem("Accommodation", tabName = "accommodation", icon = icon("bed")),
      menuItem("Transport", tabName = "transport", icon = icon("bus")),
      menuItem("Weather", tabName = "weather", icon = icon("cloud")),
      menuItem("Data Sources", tabName = "data_sources", icon = icon("database"))
    )
  ),
  dashboardBody(
    tags$head(includeCSS("www/custom.css")),
    tabItems(
      tabItem(tabName = "overview", overviewUI("overview")),
      tabItem(tabName = "restaurants", restaurantsUI("restaurants")),
      tabItem(tabName = "attractions", attractionsUI("attractions")),
      tabItem(tabName = "accommodation", accommodationUI("accommodation")),
      tabItem(tabName = "transport", transportUI("transport")),
      tabItem(tabName = "weather", weatherUI("weather")),
      tabItem(tabName = "data_sources", dataSourcesUI("data_sources"))
    )
  )
)

server <- function(input, output, session) {
  
  overviewServer("overview")
  restaurantsServer("restaurants")
  attractionsServer("attractions")
  accommodationServer("accommodation")
  transportServer("transport")
  weatherServer("weather")
  dataSourcesServer("data_sources")
}

shinyApp(ui, server, options = list(
  launch.browser = TRUE, 
  display.mode = "normal"
))