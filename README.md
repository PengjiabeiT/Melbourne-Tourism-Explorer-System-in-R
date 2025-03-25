# Melbourne Tourism Explorer
[![CN](https://img.shields.io/badge/语言-中文-red.svg)](README.md)
[![EN](https://img.shields.io/badge/Language-English-blue.svg)](README_EN.md)
## 项目背景
Melbourne Tourism Explorer是一个交互式可视化平台，旨在为墨尔本的游客提供全面的旅游信息。该平台整合了天气预测、地标热力、交通枢纽等多种动态数据源，帮助游客更好地规划行程。

## 启动说明

### 1. 必需软件
- R (4.0.0或更高版本)
- 必需的R包

### 2. 包安装
在R/RStudio中运行以下命令以安装所需的包：

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

### 3. 运行应用程序
- 打开R/RStudio
- 将工作目录设置为项目文件夹
- 运行`app.R`文件或在R控制台中输入：
  ```r
  shiny::runApp()
  ```

**注意**：应用程序将在默认的Web浏览器中打开。

## 项目结构
```
melbourne-tourism-explorer/
├── app.R          # 主应用程序文件
├── global.R       # 全局配置和库
├── www/           # 资源文件 (CSS和图片)
├── R/             # 模块文件
└── data/          # 数据文件
```

## 数据源

### 天气
- [OpenWeatherMap API](https://openweathermap.org/api)
- [Google Auth R Package Documentation](https://cran.r-project.org/web/packages/googleAuthR/vignettes/setup.html)

### 地标
- [墨尔本地标和兴趣点](https://data.melbourne.vic.gov.au/explore/dataset/landmarks-and-places-of-interest-including-schools-theatres-health-services-spor/information/)

### 住宿
- [墨尔本，维多利亚，澳大利亚，2024年9月5日](https://insideairbnb.com/get-the-data/)

### 餐厅
- [咖啡馆、餐厅、酒馆座位](https://data.melbourne.vic.gov.au/explore/dataset/cafes-and-restaurants-with-seating-capacity/information/)

### 交通
- [PTV地铁电车路线](https://discover.data.vic.gov.au/dataset/ptv-metro-tram-routes)

### Tableau
- [维多利亚公共交通数据](https://www.ptv.vic.gov.au/footer/data-and-reporting/datasets/)

### 系统展示
- [新西兰贸易情报仪表板](https://shiny.posit.co/r/gallery/government-public-sector/nz-trade-dash/)

### 概览
- [澳大利亚海外到达和离境](https://www.abs.gov.au/statistics/industry/tourism-and-transport/overseas-arrivals-and-departures-australia/aug-2024#visitor-arrivals-short-term)
