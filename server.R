## R Shiny app for FLUR (Functional LUR) model results ##
## Seyed Mahmood Taghavi Shahri © 2020
## http://mahmood-taghavi.github.io/
## License: GPL version 3.

options(shiny.error=browser)

server <- function(input, output) {


  ### tasks for region_calc button:
  observeEvent(input$region_calc, {
	  region_title = paste("Estimation of long-term PM2.5 Diurnal curve in Tehran Region", input$region_select)
    region_selected_colname = region_colnames[which(region_regnames==input$region_select)]
    fvalues = data_region[,region_selected_colname]
    tvalues = timeQuarters
    
    output$region_plot <- renderImage({
      outfile <- 'temp/region.png'
      png(outfile, width=550, height=500)
      plot(tvalues, fvalues, main=region_title, xlim=c(0,24), xlab="Time (from Hour and Minutes of 00:00 to 23:59)", ylab="Long-term PM2.5 concentrations (ug/m3)",  type="l", lwd=3, axes=FALSE, cex.lab=1.4)
      axis(1, at=0:24, cex.axis=1.4)
      axis(2, cex.axis=1.4)
      dev.off()
      
      ## Return a list containing the filename
      list(src = outfile,
           contentType = 'image/png',
           width = 440,
           height = 400,
           alt = region_title)
    }, 
    deleteFile = FALSE
    )
    
    ## show button of export figure and estimates
    shinyjs::show("download_region_fig")
    shinyjs::show("download_region_est")
    
    ## export region figure:
    output$download_region_fig <- downloadHandler(
      filename = function() {
        paste0(region_title, ".png")
      },
      content = function(file) {
        file.copy('temp/region.png',file)
      }
    )
    
    ## export region estimates:
    output$download_region_est <- downloadHandler(
      filename = function() {
        paste0(region_title, ".txt")
      },
      content = function(file) {
        #print(length(fvalues))
        region_est = data.frame(input$region_select, namesQuarters, round(fvalues, round_digits))
        colnames(region_est) = c("Region", "Time", "Estimate")
        write.table(region_est, file, row.names = FALSE, sep="\t")
      }
    )      
    
  })  # end tasks for region_calc button.
  
  
  ### tasks for curve_calc button:
  observeEvent(input$curve_calc, {
    
    curve_title = paste("Est. of long-term PM2.5 Diurnal curve at Lat=", input$curve_lat, " & Long=", input$curve_long, sep="")
    
    ## calculate fvalues
    #fvalues = data_means
    tvalues = timeMinutes
    long_num = as.numeric(input$curve_long)
    lat_num = as.numeric(input$curve_lat)
    #cat("long_num=",long_num,"\n")
    #cat("lat_num=",lat_num,"\n")
    if( any(is.na( c(long_num,lat_num) )) ){
      shinyalert("Invalid input", "The inputted coordinate must be valid numbers!", type = "error", confirmButtonCol = "#3a89b9", confirmButtonText = "OK")
    } else if(abs(lat_num)>90 | abs(long_num)>180){
      shinyalert("Invalid input", "The inputted coordinate must have valid range!", type = "error", confirmButtonCol = "#3a89b9", confirmButtonText = "OK")
    } else {
      xySFPC_CRS_sp <- coords_conv(X=long_num, Y=lat_num, projFromTo="l2s")
      #print(xySFPC_CRS_sp@coords)
      sfpc_values = sfpc_extract(xySFPC_CRS_sp)
      #print(sfpc_values)
      if ( any(is.na(sfpc_values)) ){
        shinyalert("Invalid input", "The inputted coordinate must be inside of Tehran!", type = "error", confirmButtonCol = "#3a89b9", confirmButtonText = "OK")
      } else {
        fvalues_mat = calc_fvalues(sfpc_values, data_means, data_basis)
        #cat("length(fvalues_mat)=",length(fvalues_mat),"\n")
        #cat("class(fvalues_mat)=",class(fvalues_mat),"\n")
        #cat("dim(fvalues_mat)=",dim(fvalues_mat),"\n")
        fvalues = fvalues_mat[,1]
        #cat("length(fvalues)=",length(fvalues),"\n")
        #cat("class(fvalues)=",class(fvalues),"\n")
        #cat("dim(fvalues)=",dim(fvalues),"\n")
        
        ## show button of export figure and estimates
        shinyjs::show("download_curve_fig")
        shinyjs::show("download_curve_est")
        #cat("input$curve_calc==", input$curve_calc, "\n")
        
        output$curve_plot <- renderImage({
          outfile <- 'temp/curve.png'
          png(outfile, width=550, height=500)
          plot(tvalues, fvalues, main=curve_title, xlim=c(0,24), xlab="Time (from Hour and Minutes of 00:00 to 23:59)", ylab="Long-term PM2.5 concentrations (ug/m3)", type="l", lwd=3, axes=FALSE, cex.lab=1.4)
          axis(1, at=0:24, cex.axis=1.4)
          axis(2, cex.axis=1.4)
          dev.off()
          
          ## Return a list containing the filename
          list(src = outfile,
               contentType = 'image/png',
               width = 440,
               height = 400,
               alt = curve_title)
        }, 
        deleteFile = FALSE
        )
        
        ## export curve figure:
        output$download_curve_fig <- downloadHandler(
          filename = function() {
            paste0(curve_title, ".png")
          },
          content = function(file) {
            file.copy('temp/curve.png',file)
          }
        )
        
        ## export curve estimates:
        output$download_curve_est <- downloadHandler(
          filename = function() {
            paste0(curve_title, ".txt")
          },
          content = function(file) {
            curve_est = data.frame(lat_num, long_num, namesMinutes, round(fvalues, round_digits))
            colnames(curve_est) = c("Latitude","Longitude","Time", "Estimate")
            write.table(curve_est, file, row.names = FALSE, sep="\t")
          }
        )      
      } # end else of "if ( any(is.na(sfpc_values)) )"
    } # end else of "if( any(is.na( c(long_num,lat_num) )) )"
  }) ### end tasks for curve_calc button.
  
  
  ### tasks for value_calc button:
  observeEvent(input$value_calc, {
  h = input$value_hour
  m = input$value_minute
  one_tvalues = h + (m/60)
  indexMinutes = which(timeMinutes==one_tvalues)
  #print(indexMinutes)
  
  tvalues = timeMinutes

  valuefile_time = paste("hh", strsplit(namesMinutes[indexMinutes],":")[[1]][1], "mm", strsplit(namesMinutes[indexMinutes],":")[[1]][2], sep="")
  #print(valuefile_time)
  valuefile_name = paste("Estimated long-term PM2.5 concentration at Lat=", input$value_lat, " & Long=", input$value_long, " and time ", valuefile_time, sep="")
  
  long_num = as.numeric(input$value_long)
  lat_num = as.numeric(input$value_lat)
  #cat("long_num=",long_num,"\n")
  #cat("lat_num=",lat_num,"\n")
  #ok = (sum(is.na(cbind(long_num,lat_num)))==0) # if ok be TRUE then continue else show error
  #cat("is input are numeric?", ok, "\n") 
  
  if( any(is.na( c(long_num,lat_num) )) ){
    shinyalert("Invalid input", "The inputted coordinate must be valid numbers!", type = "error", confirmButtonCol = "#3a89b9", confirmButtonText = "OK")
  } else if(abs(lat_num)>90 | abs(long_num)>180){
    shinyalert("Invalid input", "The inputted coordinate must have valid range!", type = "error", confirmButtonCol = "#3a89b9", confirmButtonText = "OK")
  } else {
    xySFPC_CRS_sp <- coords_conv(X=long_num, Y=lat_num, projFromTo="l2s")
    #print(xySFPC_CRS_sp@coords)
    sfpc_values = sfpc_extract(xySFPC_CRS_sp)
    #print(sfpc_values)
    if ( any(is.na(sfpc_values)) ){
      shinyalert("Invalid input", "The inputted coordinate must be inside of Tehran!", type = "error", confirmButtonCol = "#3a89b9", confirmButtonText = "OK")
      #showNotification("The inputted coordinate is out of the study area boundary!", type = "error")        
    } else {
      fvalues_mat = calc_fvalues(sfpc_values, data_means, data_basis)
      fvalues = fvalues_mat[,1]

      ## create value_shiny.tag to be displayed in output$value_description
      namesTime = namesMinutes
      index=indexMinutes
      
      values_description = describe_curve (fvalues, namesTime)
        
      one_text = paste("<p style=\"color:blue;\">", "Estimation of long-term PM<sub>2.5</sub> concentration at latitude=", input$value_lat, " & longitude=", input$value_long, " and time ", namesTime[index], " is ", "<strong>", round(fvalues[index], round_digits), "</strong>", " ug/m<sup>3</sup>.</p>", sep="")
      
      value_shiny.tag = tags$html(
        h4("Descriptive Result:"),
        #tags$p("Estimation of long-term PM", tags$sub("2.5"),"concentration at Latitude=", input$value_lat, "& Longitude=", input$value_long, "and time ", namesTime[index], "is", tags$strong(round(fvalues[index], round_digits)), "µg/m", tags$sup(3), "."),
        HTML(one_text),
        h4("Change over time:"),
        #p("aaaa")
        tags$p("The minimum of estimating long-term values in this coordinate is", round(values_description$minfvalues, round_digits), "(ug/m3) that occurs at time of", values_description$name_minfvalues, " and the maximum value is", round(values_description$maxfvalues, round_digits), "(ug/m3) that occurs at time of", values_description$name_maxfvalues),
        tags$p("The first quartile of estimating long-term values in this coordinate is", round(values_description$q1fvalues, round_digits), "(ug/m3), the median is", round(values_description$q2fvalues, round_digits), "(ug/m3), and the third quartile is", round(values_description$q3fvalues, round_digits),"(ug/m3)."),
        tags$p("The average of estimating long-term values in this coordinate is", round(values_description$avgfvalues, round_digits), " (ug/m3) and the estimated standard deviation is", round(values_description$sdfvalues, round_digits),"(ug/m3).")
      )
      
      ## render value description at output box
      output$value_description <- renderUI({       
        value_shiny.tag
      })
      
      ## save value description to the temporary html file
      save_html(value_shiny.tag, filePath="temp/value.html")

      ## show button of download_value_description
      shinyjs::show("download_value_description")
  
      ## export value description:
      output$download_value_description <- downloadHandler(
        filename = function() {
          paste0(valuefile_name, ".html")
        },
        content = function(file) {
          file.copy('temp/value.html',file)
        }
      )
      
    } # end else of "if ( any(is.na(sfpc_values)) )"
  } # end else of "if( any(is.na( c(long_num,lat_num) )) )"
  }) # end tasks for value_calc button.
  
  
  ### tasks for map_calc button:
  observeEvent(input$map_calc, {
    
    h = input$map_hour
    m = input$map_minute
    tvalues = h + (m/60)
    indexMinutes = which(timeMinutes==tvalues)
    #print(indexMinutes)
    
    map_title = bquote(paste("Estimation of long-term ", PM[2.5], " concentrations in Tehran at ", .(namesMinutes[indexMinutes])))
    
    oneTimePoint_mean = data_means[indexMinutes]
    #print(oneTimePoint_mean)
    
    oneTimePoint_basis = data_basis[indexMinutes,]
    #print(oneTimePoint_basis)
    
    oneTimePoint_QL_lower = QL_lower[indexMinutes]
    #print(oneTimePoint_QL_lower)
    
    oneTimePoint_QL_upper = QL_upper[indexMinutes]
    #print(oneTimePoint_QL_upper)

    map_raster = calc_map(oneTimePoint_mean, oneTimePoint_basis, oneTimePoint_QL_lower, oneTimePoint_QL_upper)
    
    #print(map_raster)
    
    output$map_plot <- renderImage({
      outfile <- 'temp/map.png'
      png(outfile, width=550, height=500)
      
      #plot(map_raster, main=map_title)
      
      minval = min(QL_lower)
      maxval = max(QL_upper)
      n = 18
      breaks = seq(floor(minval), ceiling(maxval), length.out = n+1)
      color = colorRampPalette(c("darkgreen", "yellow","red","brown"))( n )
      legendText = "concentrations (µg/m3)"
      xlab = "UTM zone 39N: Easting (km)"
      ylab = "UTM zone 39N: Northing (km)"
      
      plot(map_raster, breaks=breaks, col=color, xlab=xlab, ylab=ylab, 
           main= map_title, cex.main = 1.5, cex.lab = 1.5, cex.axis=1.5, 
           legend.width = 1, legend.shrink=1, axis.args=list( cex.axis=1.5),
           legend.args = list(text = legendText, side = 2, line = 0.3, cex = 1.5))
      
      dev.off()
      
      ## Return a list containing the filename
      list(src = outfile,
           contentType = 'image/png',
           width = 440,
           height = 400,
           alt = map_title)
    }, 
    deleteFile = FALSE
    )
    
    ## show button of export figure and estimates
    shinyjs::show("download_map_est")
    shinyjs::show("download_map_fig")
    
    mapfile_time = paste("hh", strsplit(namesMinutes[indexMinutes],":")[[1]][1], "mm", strsplit(namesMinutes[indexMinutes],":")[[1]][2], sep="")
    print(mapfile_time)
    mapfile_name = paste("Estimation of long-term PM2.5 concentrations in Tehran at time", mapfile_time)
    
    ## export map figure:
    output$download_map_fig <- downloadHandler(
      filename = function() {
        paste0(mapfile_name, ".png")
      },
      content = function(file) {
        #print(mapfile_name)
        #print(file)
        file.copy('temp/map.png',file)
      }
    )
    
    ## export map estimates:
    output$download_map_est <- downloadHandler(
      filename = function() {
        paste0(mapfile_name, ".asc")
      },
      content = function(file) {
        #print(mapfile_name)
        #print(file)
        writeRaster(map_raster, file, "ascii")
      }
    )
  }) # end tasks for map_calc button
  
  
} # end of the server.R function
