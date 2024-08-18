#############################################
# Code author Dominik Vugrinec
#############################################

# Loading in the required libraries to run the shiny app
library(shiny)
library(tidyverse)
library(maps)
library(ggplot2)
library(lubridate)
library(leaflet)


# Loading in the required data prior to starting the shiny app
earthquakes <- read.csv("./eq_mag5plus_2014_2024.csv",header = TRUE)

# Preprocessing the data
earthquakes$time <- ymd_hms(earthquakes$time)
earthquakes$updated <- ymd_hms(earthquakes$updated)  




# The ui segment of the shiny app
ui <- fluidPage(
  
  titlePanel("Quake mapper"),
  
  # Sidebar with a slider input used for determining the date range of interest 
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "date_range",
        label = "Select a date range:",
        min = min(earthquakes$time), # Locating the minimum date in the earthquake dataset  
        max = max(earthquakes$time), # Locating the maximum date in the earthquake dataset
        value = c(min(earthquakes$time), max(earthquakes$time)),  # Set inital range of dates upon shiny app startup
        timeFormat = "%Y-%m-%d"  # Format of the date in the slider
      ),
      shiny::actionButton(inputId = "select",label = "Select time period",icon = icon("check"))
    ),
    
    # Main panel ui segments consisting of three different plots
    mainPanel(
      # Heading for the main panel just to make it look a bit nice
      h2("Map of all Eearthquakes"),
      fluidRow(
        column(6, plotOutput("hist")),   # Histogram plot of earthquake counts per month in the selected date range  
        column(6, plotOutput(outputId = "map")), # World map plot with all the earthquake spots in the selected date range
      ),
      leafletOutput("mymap",height = 800)
    )
  )
)



# Server logic section of the shiny app
server <- function(input, output) {
  
  
  # Observe event that activates each time the action button labeled "Select time period" is pressed
  observeEvent(input$select,{
    
    # Filter the earthquake dataset to be in the user selected data range
    earthquakes2 <- earthquakes[earthquakes$time >= input$date_range[1] & earthquakes$time <= input$date_range[2], ]
    
    # Get the world map data to be able to make a plot of the world map
    world <- map_data('world')
    
    # Creating the title for the world map 
    title <- paste("Earthquakes map from ", paste(as.Date(earthquakes2$time[1]), as.Date(earthquakes2$time[nrow(earthquakes2)]), sep = " to "))
    
    # Creating the world map plot and adding visual features such as size and colour
    p <- ggplot() + geom_map(data = world, map = world, aes(x = long, y=lat, group=group, map_id=region), fill="white", colour="#7f7f7f", size=0.5)
    
    # Adding the filtered earthquake data overlay as points on the world map, with a colour gradient based on their magnitude
    p <- p + geom_point(data = earthquakes2, aes(x=earthquakes2$longitude, y = earthquakes2$latitude, colour = mag)) + scale_colour_gradient(low = "blue",high = "red") 
    
    # Adding the title to the plot
    p <- p + ggtitle(title) 
    
    # Rendering the world map plot
    output$map <- renderPlot({p})
    
    # Rendering the histogram based on the filtered data from the user selected date range
    output$hist <- renderPlot({hist(earthquakes2$time,breaks = "months",xlab = "Months",freq = TRUE)})
    
    
    ########## Creating an interactive map using leaflet package. #################
    
    qMap <- earthquakes2 %>% leaflet() %>% addTiles() %>% 
      addMarkers(~longitude, ~latitude,
                 popup = (paste("Place: ", earthquakes2$place, "<br>", 
                                "Id: ", earthquakes2$id, "<br>",
                                "Time: ", earthquakes2$time, "<br>",
                                "Magnitude: ", earthquakes2$mag, " m <br>",
                                "Depth: ", earthquakes2$depth)),
                 clusterOptions = markerClusterOptions())
    
    # Rendering the leaflet plot
    output$mymap <- renderLeaflet({qMap})
    ##################################################################
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
