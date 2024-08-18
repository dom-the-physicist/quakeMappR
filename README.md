# quakeMappR

This is a shiny app tool created as a demonstration of building and deploying a basic shiny app.

It consists of single app file that houses the Ui and Server segments of the shiny app.

The app itself loads a data file that contains information about Earthquakes in a time period of 2014 to 2024, it then allows the user to pick a time frame they are interested in. Once the user confirms the date range they want to view, the tool will create three individual plots:

  1. First plot contains a histogram that shows the number of earthquakes that occurred by month in that date range.
  
  2. The second plot is a world map that indicates the locations of all the earthquakes in that specific time period and colour          codes them by magnitude.
  
  3. The last is a interactive map, which shows the users the number of earthquakes that occurred in each region for the selected        time period, it also allows the user to zoom in and click on individual earthquake occurrences to get more information about        them. 
  

The shiny app is currently deployed on the following url: https://dom-vugrinec.shinyapps.io/quakemappr/

Package requirements to run this shiny tool and their versions at the time of development:

- shiny (version 1.8.1.1)
- tidyverse (version 2.0.0)
- maps (version 3.4.2)
- ggplot2 (version 3.5.1)
- lubridate (version 1.9.3)
- leaflet (version 2.2.2)
- shinyjs (version 2.1.0)


