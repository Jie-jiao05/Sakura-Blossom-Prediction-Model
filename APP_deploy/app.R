library(shiny)
library(ggplot2)
library(dplyr)
library(readr)
library(patchwork)

temp_data <- read_csv("temperatures_with_station_names.csv")
stations_data <- read_csv("Stations_Name_Lat_Lon__Cleaned_.csv")

#Model

beta_0 <- -47.4751
beta_temp <- 0.3315
beta_lat <- 4.8615
beta_lon <- -0.2695

# 预测花期函数
predict_flowering_day <- function(year, lat, lon, jan_temp = NA, feb_temp = NA, mar_temp = NA) {
  if (is.na(jan_temp)) jan_temp <- 5.0 + 0.03 * (year - 2023)
  if (is.na(feb_temp)) feb_temp <- 6.0 + 0.035 * (year - 2023)
  if (is.na(mar_temp)) mar_temp <- 8.0 + 0.04 * (year - 2023)
  
  wacc <- 0.2 * jan_temp + 0.3 * feb_temp + 0.5 * mar_temp
  doy <- beta_0 + beta_temp * wacc + beta_lat * lat + beta_lon * lon
  return(list(doy = round(doy, 1), wacc = wacc))
}

# UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
            .title-bar {
                background-color: #FADADD;
                padding: 8px;
                font-size: 22px;
                font-weight: bold;
                text-align: center;
                color: #4F4F4F;
            }
            .result-box {
                border: 2px solid #FF69B4;
                background-color: #FFF5F7;
                padding: 15px;
                font-size: 18px;
                font-weight: bold;
                color: #333;
                text-align: center;
                font-family: 'Arial', sans-serif;
                box-shadow: 0px 2px 4px rgba(0,0,0,0.1);
            }
        "))
  ),
  
  div(class = "title-bar", "Sakura Flowering Date Predictor (All Japan Region)"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("station", "Choose Station:", choices = unique(stations_data$station_name)),
      numericInput("year", "Predict flowering for year:", value = 2025, min = 1980, max = 2050),
      numericInput("jan_temp", "January Temperature (°C, optional)", value = NA, step = 0.1),
      numericInput("feb_temp", "February Temperature (°C, optional)", value = NA, step = 0.1),
      numericInput("mar_temp", "March Temperature (°C, optional)", value = NA, step = 0.1),
      actionButton("predict", "Predict Flowering Day"),
      helpText("Leave temperatures blank to use projected climate warming."),
      wellPanel(
        h4("📖 About the Model"),
        p("This model predicts flowering days using Bayesian hierarchical regression, incorporating climate change (WACC) and station locations (latitude/longitude) cross Japan."),
        p("WACC = weighted average of January, February, and March temperatures."),
        p("Sakura blossom date and temperature data are sourced by Japan Meteorological Agency (JMA)."),
        tags$code("DOY = β0 + β1 * WACC + β2 * Latitude + β3 * Longitude")
      )
    ),
    
    mainPanel(
      uiOutput("result_box"),
      plotOutput("trend_plot", height = "500px")
    )
  )
)

# Server
server <- function(input, output) {
  predicted <- reactiveVal(NULL)
  
  observeEvent(input$predict, {
    station_data <- stations_data %>%
      filter(station_name == input$station)
    
    lat <- station_data$latitude
    lon <- station_data$longitude
    
    res <- predict_flowering_day(input$year, lat, lon, 
                                 input$jan_temp, input$feb_temp, input$mar_temp)
    predicted(list(res = res, lat = lat, lon = lon))
  })
  
  output$result_box <- renderUI({
    req(predicted())
    res <- predicted()$res
    
    div(class = "result-box",
        paste0("🌸 Predicted Flowering Day for ", input$year, " at ", input$station, ": ", res$doy, " DOY"),
        br(),
        paste0("📊 Calculated WACC: ", round(res$wacc, 2), "°C")
    )
  })
  
  output$trend_plot <- renderPlot({
    req(predicted())
    lat <- predicted()$lat
    lon <- predicted()$lon
    
    years <- seq(1980, input$year, 1)
    doys <- sapply(years, function(y) predict_flowering_day(y, lat, lon)$doy)
    
    baseline <- predict_flowering_day(1953, lat, lon)$doy
    delta_doy <- doys - baseline
    
    flowering_data <- data.frame(year = years, delta_doy = delta_doy)
    
    # 选站点真实3月温度
    march_temps <- temp_data %>%
      filter(station_name == input$station, month == "Mar", year >= 1980, year <= input$year) %>%
      select(year, mean_temp_c)
    
    # 主图 ΔDOY
    p1 <- ggplot(flowering_data, aes(x = year, y = delta_doy)) +
      geom_line(color = "steelblue", size = 1) +
      geom_smooth(method = "lm", se = FALSE, color = "darkblue", linetype = "dashed") +
      scale_y_continuous(breaks = seq(-20, 20, by = 5)) +
      labs(title = paste0("Change in Flowering Day at ", input$station),
           x = "Year", y = "Deviation from 1953 Flowering Day (Days)") +
      theme_minimal(base_size = 14)
    
    # 小图 3月温度
    p2 <- ggplot(march_temps, aes(x = year, y = mean_temp_c)) +
      geom_line(color = "darkorange", size = 1) +
      geom_point(color = "darkorange", size = 2) +
      labs(title = paste0("March Temperature at ", input$station),
           x = "Year", y = "Temperature (°C)") +
      theme_minimal(base_size = 10)
    
    # 主+小图拼图
    p1 + inset_element(p2, left = 0.7, bottom = 0.05, right = 0.99, top = 0.4, align_to = "panel")
  })
}

# 启动App
shinyApp(ui, server)
