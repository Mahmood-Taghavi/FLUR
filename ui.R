## R Shiny app for FLUR (Functional LUR) model results ##
## Seyed Mahmood Taghavi Shahri © 2020
## http://mahmood-taghavi.github.io/
## License: GPL version 3.

library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinyalert)
library(shinydisconnect)


ui <- dashboardPage(
  dashboardHeader(title = "FLUR: Tehran PM2.5"),
  #dashboardHeader(title = HTML("<p>FLUR: Tehran PM<sub>2.5</sub> Estimation</p>")),
  skin = "green",
  #dashboardHeader(disable = TRUE),

  
  ### Designing the sidebar contents
  dashboardSidebar(
    sidebarMenu(
      tags$html(lang="en", dir="ltr"),
      menuItem("Diurnal Estimation in Regions", tabName = "region", icon = icon("globe")),
      menuItem("Diurnal Est. in Coordinates", tabName = "curve", icon = icon("compass")),
      menuItem("Point Est. in Coords. & Time", tabName = "value", icon = icon("dashboard")),
      menuItem("Full Map Estimation at Time", tabName = "map", icon = icon("images")),
      menuItem("About Me, Model, and more", tabName = "about", icon = icon("info"))
    )
  ),
  
  ## Body content
  dashboardBody(
    tags$html(lang="en", dir="ltr"),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "text-justify.css")
    ),
    useShinyalert(),  # Set up shinyalert
    useShinyjs(),
    disconnectMessage(
      text = "Conection to the R server is lost!",
      refresh = "Try Again",
      background = "#FFFFFF",
      colour = "#444444",
      overlayColour = "#000000",
      overlayOpacity = 0.77,
      width = "full",
      top = 280,
      size = 22,
      css = ""
    ),
    tabItems(
      
      ### Designing the region' tab GUI
      tabItem(tabName = "region",
              fluidRow(
                column(width = 6,
                      box(title = "Diurnal Estimation in Regions", width=NULL, 
                        includeHTML("www/region.html")
                      ),
                      box(title = "Input", width=NULL,
                        "Please select one of Tehran's regions:", 
                        selectInput("region_select","Region:", choices=region_regnames),
                        actionButton("region_calc", "Calculate")
                      )
                ),
                column(width = 6, 
                  box(title = "Output", width=NULL,
                    plotOutput("region_plot")
                  )
                )
              ),
              fluidRow(
                box(title = "Save the curve values", width=6,
                    shinyjs::hidden(downloadButton("download_region_est", "Download the generated file ..."))
                ),
                box(title = "Save the curve image", width=6,
                    shinyjs::hidden(downloadButton("download_region_fig", "Download the generated file ..."))
                )
              )
      ),

      
      ### Designing the curves' tab GUI
      tabItem(tabName = "curve",
              fluidRow(
                column(width = 6,
                       box(title = "Diurnal Est. in Coordinates", width=NULL, 
                           includeHTML("www/curve.html")
                       ),
                       box(title = "Input", width=NULL,
						               "Please insert the coordinates of a geo-point in Tehran:",
                           textInput("curve_lat","Latitude (e.g. 35.701052 for the Enghelab Square)", value = "35.701052"),
                           textInput("curve_long","Longitude (e.g. 51.391539 for the Enghelab Square)", value = "51.391539"),
                           actionButton("curve_calc", "Calculate")
                       )
                ),
                column(width = 6,
                       box(title = "Output", width=NULL,
                           plotOutput("curve_plot")
                       )
                )
              ),
              fluidRow(
                box(title = "Save the curve values", width=6,
                    shinyjs::hidden(downloadButton("download_curve_est", "Download the generated file ..."))
                ),
                box(title = "Save the curve image", width=6,
                    shinyjs::hidden(downloadButton("download_curve_fig", "Download the generated file ..."))
                )
              )
      ),
      
      
      ### Designing the value' tab GUI
      tabItem(tabName = "value",
              box(title = "Point Est. in Coords. & Time", width=NULL, 
                  includeHTML("www/value.html")
              ),
              fluidRow(
                column(width = 6,
                  box(title = "Input", width=NULL, 
                    "Please specify the coordinates of a geo-point in Tehran and also a time point:",
                    textInput("value_lat","Latitude (e.g. 35.701052 for the Enghelab Square)", value = "35.701052"),
                    textInput("value_long","Longitude (e.g. 51.391539 for the Enghelab Square)", value = "51.391539"),
                    sliderInput("value_hour", "Hour: ", 0, 23, 0),
                    sliderInput("value_minute", "Minute: ", 0, 59, 0),
                    actionButton("value_calc", "Calculate")
                  )
                ),
                column(width = 6,
                       box(title = "Output", height = 370, width=NULL, 
                           uiOutput("value_description"),
                       ),
                       box(title = "Save the descriptive result", width=NULL,
                       shinyjs::hidden(downloadButton("download_value_description", "Download the generated file ..."))
                       )
                )
              )
      ),      
      
      
      ### Designing the map' tab GUI
      tabItem(tabName = "map",
              fluidRow(
                column(width = 6,
                       box(title = "Full Map Estimation at Time", width=NULL, 
                           includeHTML("www/map.html")
                       ),
                      box(title = "Input", width =NULL,
                        "Please select a time point:",
                        sliderInput("map_hour", "Hour: ", 0, 23, 0),
                        sliderInput("map_minute", "Minute: ", 0, 59, 0),
                        actionButton("map_calc", "Calculate")
                      )
                ),
                column(width = 6,
                       box(title = "Output", width =NULL,
                           plotOutput("map_plot")
                       )
                )
              ),
              fluidRow(
                box(title = "Save the map values",
                    shinyjs::hidden(downloadButton("download_map_est", "Download the generated file ..."))
                ),
                box(title = "Save the map image",
                    shinyjs::hidden(downloadButton("download_map_fig", "Download the generated file ..."))
                )
              )
      ),

      
      ### Designing the about' tab GUI
      tabItem(tabName = "about",
              #h2("About software and its developer:"),
              box(title = "About Me", width = NULL,
                  "I am Mahmood Taghavi, a Biostatistician with an affinity for programming, data science, and data analysis.",
                  br(),
                  "You can find all of my open-source projects at my GitHub profile:",
                  tags$a(href = "https://github.com/Mahmood-Taghavi", "https://github.com/Mahmood-Taghavi"),
                  br(),
                  "The current update of this app is released on 22 Dec. 2020"
              ),
            
              box(title = "About Statistical Model", width = NULL,
                  "This app presents the results of a novel Land-Use Regression model with a Functional response variable.",
                  br(),
                  "The long-term PM2.5 Diurnal Variation Curves measured in the mega-city of Tehran is the model response.",
                  br(),
                  "The spatial predictors are: 1. Natural logarithm of distance to nearest road (m); 2. Total population density in buffer radii of 2750 m
(persons per km 2 ); 3. Arid or undeveloped land-use area in buffer radii
of 200 m (m 2 ); 4. Residual of recognizable land-use areas in buffer
radii of 400 m (m 2 ).",
                  br(),
                  "Details will be available at a submitted paper for publication entitled: 'A novel Land-Use Regression model for high-resolution spatial estimation of long-term PM 2.5 diurnal variation curves in the middle eastern megacity of Tehran'.",
              ),
			
              box(title = "About Applications", width = NULL,
                "This data provided by this app is ready for use in epidemiological studies of air pollution health effects. Especially, exposure assessment for long-term PM2.5 is interesting in studying chronic conditions resulted from air pollution."
              ), 
              
              box(title = "About Technologies", width = NULL,
                  "R statistical environment and the 'fda' and 'raster' packages are specifically used for data modeling (FDA: Functional Data Analysis).",
                  br(),
                  "The following R packages are used in developing this interactive app: 'shiny', 'shinydashboard', 'shinyalert', 'shinydisconnect', 'shinyjs', 'htmltools', 'sp', 'rgdal', and 'raster'.",
              )
      )
      
    ),
    tags$head(tags$style(HTML(
      '.myClass { 
        font-size: 15px;
        line-height: 50px;
        text-align: left;
        padding: 0 15px;
        overflow: hidden;
        color: white;
      }
    '))),
    tags$script(HTML(headerText))
  )
)
