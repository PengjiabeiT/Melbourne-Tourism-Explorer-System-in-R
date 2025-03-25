# Melbourne Tourism Explore
[![CN](https://img.shields.io/badge/语言-中文-red.svg)](README.md)
[![EN](https://img.shields.io/badge/Language-English-blue.svg)](README_EN.md)
## Launch Instructions

### 1. Required Software
- R (4.0.0 or higher)
- Required R packages

### 2. Package Installation
Run the following command in R/RStudio:

```r
install.packages(c(
  "shiny",
  "shinydashboard",
  "leaflet",
  "dplyr",
  "plotly",
  "DT",
  "httr",
  "jsonlite",
  "ggplot2",
  "readr",
  "shinyWidgets",
  "leaflet.extras",
  "shinyjs",
  "tidyr",
  "RColorBrewer",
  "magrittr"
))
```

### 3. Running the Application
- Open R/RStudio
- Set working directory to project folder
- Run `app.R` file or input in R console:
  ```r
  shiny::runApp()
  ```

**Note**: The application will open in your default web browser.

## Project Structure
```
melbourne-tourism-explorer/
├── app.R          # Main application file
├── global.R       # Global configurations and libraries
├── www/           # Assets (CSS and images)
├── R/             # Module files
└── data/          # Data files
```

## Data Sources for Different Functions

### Weather
- [OpenWeatherMap API](https://openweathermap.org/api)
- [Google Auth R Package Documentation](https://cran.r-project.org/web/packages/googleAuthR/vignettes/setup.html)

### Landmark
- [Landmarks and places of interest in Melbourne](https://data.melbourne.vic.gov.au/explore/dataset/landmarks-and-places-of-interest-including-schools-theatres-health-services-spor/information/)

### Accommodation
- [Melbourne, Victoria, Australia, 05 September 2024](https://insideairbnb.com/get-the-data/)

### Restaurants
- [Café, restaurant, bistro seats](https://data.melbourne.vic.gov.au/explore/dataset/cafes-and-restaurants-with-seating-capacity/information/)

### Transport
- [PTV Metro Tram Routes](https://discover.data.vic.gov.au/dataset/ptv-metro-tram-routes)

### Tableau
- [Victorian public transport data](https://www.ptv.vic.gov.au/footer/data-and-reporting/datasets/)

### System Display
- [New Zealand Trade Intelligence Dashboard](https://shiny.posit.co/r/gallery/government-public-sector/nz-trade-dash/)

### Overview
- [Overseas Arrivals and Departures, Australia](https://www.abs.gov.au/statistics/industry/tourism-and-transport/overseas-arrivals-and-departures-australia/aug-2024#visitor-arrivals-short-term)
