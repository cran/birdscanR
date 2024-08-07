#### plotExploration ------------------------------------------------------
#' @title plotExploration
#'
#' @author Fabian Hertner, \email{fabian.hertner@@swiss-birdradar.com}; 
#' Birgen Haest, \email{birgen.haest@@vogelwarte.ch}  
#' @description This function creates a time series plot showing all of the 
#' observed echoes at their respective altitudes. These plots are helpful to 
#' roughly visually explore your data (and for example spot oddities).
#' @param echoData dataframe with the echo data from the data list created by 
#' the function ‘extractDBData’ or a subset of it created by the function 
#' ‘filterEchoData’
#' @param timeRange optional list of string vectors length 2, start and end 
#' time of the time ranges that should be plotted. The date/time format is 
#' “yyyy-MM-dd hh:mm”. If not set, all echo data is plotted in one plot.  
#' Note: Too long time-ranges may produce an error if the created image is too 
#' large and the function can’t allocate the file. 
#' @param targetTimeZone "Etc/GMT0" String specifying the target time zone. 
#' Default is "Etc/GMT0".
#' @param manualBlindTimes optional dataframe with the manual blind times 
#' created by the function ‘loadManualBlindTimes’. If not set, manual blind 
#' times are not shown in the plot. 
#' @param visibilityData optional dataframe with the visibility data created by 
#' the function ‘extractDBData’. If not set, visibility data are not shown in 
#' the plot. 
#' @param protocolData optional dataframe with the protocol data used to filter 
#' the echoes, created by the function ‘extractDBData’ or a subset of it created 
#' by the function ‘filterProtocolData’. If not set, periods without a protocol 
#' are not shown in the plot. 
#' @param sunriseSunset optional dataframe with sunrise/sunset, civil, and nautical  
#' twilight times created by the function ‘twilight’. If not set, day/night 
#' times are not shown in the plot. 
#' @param maxAltitude optional numeric, fixes the maximum value of the y-Scale 
#' of the plot to the given value. If negative or not set, the y-Scale is 
#' auto-scaled.
#' @param filePath character string, path of the directory where the plot 
#' should be saved. The function ‘savePlotToFile’ is used to save the plots as 
#' png files with an auto-generated filename.
#'
#' @return png files stored in the directory specified in 'filePath'
#' @export
#'
#' @examples 
#' \dontrun{
#' #' # Set server, database, and other input settings
#' # ===========================================================================
#'   dbServer       = "MACHINE\\SERVERNAME"     # Set the name of your SQL server
#'   dbName         = "db_Name"                   # Set the name of your database
#'   dbDriverChar   = "SQL Server"                # Set either "SQL Server" or "PostgreSQL"
#'   mainOutputDir  = file.path(".", "results")
#'   radarTimeZone  = "Etc/GMT0"
#'   targetTimeZone = "Etc/GMT0"
#'   listOfRfFeaturesToExtract = c(167, 168)
#'   siteLocation   = c(47.494427, 8.716432)
#'   sunOrCivil     = "civil"
#'  
#' # Get data
#' # ===========================================================================
#'   dbData = extractDbData(dbDriverChar                   = dbDriverChar,
#'                          dbServer                       = dbServer, 
#'                          dbName                         = dbName, 
#'                          saveDbToFile                   = TRUE,
#'                          dbDataDir                      = mainOutputDir,
#'                          radarTimeZone                  = radarTimeZone,
#'                          targetTimeZone                 = targetTimeZone,
#'                          listOfRfFeaturesToExtract      = listOfRfFeaturesToExtract,
#'                          siteLocation                   = siteLocation, 
#'                          sunOrCivil                     = sunOrCivil)
#'                          
#' # Get manual blindtimes
#' # ===========================================================================
#'   data("manualBlindTimes")
#'   cManualBlindTimes = manualBlindTimes
#' 
#' # Make Plot 
#' # ===========================================================================
#'   timeRangePlot = list(c("2021-01-15 00:00", "2021-01-22 00:00"),
#'                        c("2021-01-23 00:00", "2021-01-31 00:00"))
#'   plotExploration(echoData         = dbData$echoData, 
#'                   timeRange        = timeRangePlot, 
#'                   targetTimeZone   = "Etc/GMT0",
#'                   manualBlindTimes = cManualBlindTimes, 
#'                   visibilityData   = dbData$visibilityData, 
#'                   protocolData     = dbData$protocolData, 
#'                   sunriseSunset    = dbData$sunriseSunset, 
#'                   maxAltitude      = -1, 
#'                   filePath         = "./") 
#' }
#' 
plotExploration = function(echoData         = NULL, 
                           timeRange        = NULL, 
                           targetTimeZone   = "Etc/GMT0",
                           manualBlindTimes = NULL, 
                           visibilityData   = NULL, 
                           protocolData     = NULL, 
                           sunriseSunset    = NULL, 
                           maxAltitude      = NULL, 
                           filePath         = NULL){
  # If there is echodata, proceed
  # =============================================================================
  if (!is.null(echoData)){
    # colors for classes
    # =========================================================================
    classColors = c("nonbio"         = "grey40",
                    "precipitation"  = "grey60",
                    "insect"         = "orange",
                    "unid_bird"      = "darkblue",
                    "passerine_type" = "turquoise3",
                    "wader_type"     = "chartreuse3",
                    "swift_type"     = "deeppink",
                    "large_bird"     = "purple",
                    "bird_flock"     = "forestgreen",
                    "bat"            = "darkred" )
    
    # shapes for classes
    # =========================================================================
    classShapes = c("nonbio"         = 0,
                    "insect"         = 4,
                    "unid_bird"      = 1,
                    "passerine_type" = 1,
                    "wader_type"     = 1,
                    "swift_type"     = 1,
                    "large_bird"     = 1,
                    "bird_flock"     = 1,
                    "bat"            = 1,
                    "precipitation"  = 5)
    
    # size for shapes
    # =========================================================================
    shapeSizes = data.frame( class = c("nonbio",
                                       "insect"         ,
                                       "unid_bird"      ,
                                       "passerine_type" ,
                                       "wader_type"     ,
                                       "swift_type"     ,
                                       "large_bird"     ,
                                       "bird_flock"     ,
                                       "bat"            ,
                                       "precipitation"  ),
                             shapeSize = c( 0.1, 
                                            0.4,
                                            0.1,
                                            0.1,
                                            0.1,
                                            0.1,
                                            0.1,
                                            0.1,
                                            0.1,
                                            0.1)
                                            )
    
    # backgroundDataColor
    # =========================================================================
    backgroundColors = c("day"                  = "goldenrod1",
                         "night"                = "navy",
                         "manual blindtime"     = "dodgerblue",
                         "visibility blindtime" = "firebrick1",
                         "no protocol"          = "turquoise4")
    
    # day/night colors
    # =========================================================================
    dayNightColors = c("day" = "goldenrod1", "night" = "navy")
    
    # class levels
    # =========================================================================
    echoData <- echoData[!is.na(echoData$class),]
    classLevels = c("passerine_type", "wader_type", "swift_type", 
                    "large_bird", "unid_bird", "bird_flock", "bat",
                    "insect", "nonbio", "precipitation")
    echoData$class = factor(echoData$class, levels = classLevels)
    
    # background levels
    # =========================================================================
    backgroundLevels = c("day", "night", "manual blindtime", 
                         "visibility blindtime", "no protocol")
    
    if (!is.null(sunriseSunset)){
      # change sunrise/sunset data from 0/1 to day/night
      # =======================================================================
      sunriseSunset$is_night[sunriseSunset$is_night != 1] = "day"
      sunriseSunset$is_night[sunriseSunset$is_night == 1] = "night"
    }
    
    # Convert the timeRange input to a POSIXct object, if it was defined
    # =========================================================================
    if (!is.null(timeRange)){
      posixCTListCon = function(x){
        as.POSIXct(x, format = "%Y-%m-%d %H:%M", tz = targetTimeZone)
      }
      timeRange = lapply(timeRange, posixCTListCon)
    }
    
    # timeRanges to plot
    # =========================================================================
    if (is.null(timeRange)){
      nPlots = 1
    } else {
      nPlots = length(timeRange)
    }
    
    # Do for each time range
    # =========================================================================  
    for (i in 1:nPlots){
      if (is.null(timeRange)){
        echoDataPlot = echoData
        timeRange    = list(c(min(echoDataPlot$time_stamp_targetTZ), max(echoDataPlot$time_stamp_targetTZ)))
      } else {
        echoDataPlot = echoData[(echoData$time_stamp_targetTZ >= timeRange[[i]][1]) & 
                                  (echoData$time_stamp_targetTZ <= timeRange[[i]][2]),]  
      }
      
      if (nrow(echoDataPlot) >= 0){
        # set y scale
        # ===================================================================
        if (maxAltitude > 0){
          yScale = c(-0.03 * maxAltitude, maxAltitude)
        } else {
          yScale = c(-0.03 * max(echoDataPlot$feature1.altitude_AGL), 1.1 * max(echoDataPlot$feature1.altitude_AGL))
        }
        
        # Plot
        # ===================================================================
        subtitle = paste0(format(timeRange[[i]][1], "%d-%b-%Y"), 
                          " to ", 
                          format(timeRange[[i]][2], "%d-%b-%Y"))
        explorationPlot = ggplot2::ggplot()
        
        # create background data
        # ===================================================================
        background = data.frame(xStart = as.POSIXct(NA), 
                                xStop  = as.POSIXct(NA), 
                                yStart = as.numeric(NA), 
                                yStop  = as.numeric(NA), 
                                type   = factor(NA, levels = backgroundLevels))
        
        if (!is.null(manualBlindTimes)){
          manualBlindTimes$type = "manual blindtime"
          background = rbind(background, 
                             data.frame(xStart = manualBlindTimes$start_targetTZ, 
                                        xStop  = manualBlindTimes$stop_targetTZ, 
                                        yStart = -0.06 * yScale[2], 
                                        yStop  = -0.04 * yScale[2], 
                                        type   = manualBlindTimes$type))
        }
        
        if (!is.null(sunriseSunset)){
          background = rbind(background, 
                             data.frame(xStart = sunriseSunset$civilStart, 
                                        xStop  = sunriseSunset$civilStop, 
                                        yStart = 0.93 * yScale[2], 
                                        yStop  = yScale[2], 
                                        type   = sunriseSunset$is_night))
        }
        
        if (!is.null(visibilityData)){
          background = rbind(background, 
                             data.frame(xStart = visibilityData$blind_from_targetTZ, 
                                        xStop  = visibilityData$blind_to_targetTZ, 
                                        yStart = -0.02 * yScale[2], 
                                        yStop  = -0.00 * yScale[2], 
                                        type   = "visibility blindtime"))  
        }
        
        if (!is.null(protocolData)){
          background = rbind(background, 
                             data.frame(xStart = protocolData$stopTime_targetTZ[1:(length(protocolData[, 1])-1)], 
                                        xStop  = protocolData$startTime_targetTZ[2:length(protocolData[, 1])], 
                                        yStart = -0.04 * yScale[2], 
                                        yStop  = -0.02 * yScale[2], 
                                        type   = "no protocol"))  
        }
        
        # limit background to echoData
        # ===================================================================
        background = background[!is.na(background$xStart),]
        background = background[background$xStop >= min(echoDataPlot$time_stamp_targetTZ) & 
                                  background$xStart <= max(echoDataPlot$time_stamp_targetTZ),]
        
        # add background to plot
        # ===================================================================
        if (length(background) > 1){
          explorationPlot = explorationPlot + 
            ggplot2::geom_rect(background, 
                               mapping = ggplot2::aes(ymin = yStart , 
                                                      ymax = yStop, 
                                                      xmin = xStart, 
                                                      xmax = xStop, 
                                                      fill = type), 
                               alpha = 0.5)  
        }
        
        # plot echoes
        # ===================================================================
        explorationPlot = explorationPlot + 
          ggplot2::geom_point(echoDataPlot, 
                              mapping = ggplot2::aes(x      = time_stamp_targetTZ, 
                                                     y      = feature1.altitude_AGL, 
                                                     colour = class, 
                                                     shape = class),
                              size   = 1, 
                              alpha = 0.7, 
                              na.rm = TRUE)
        
        # overprint insect classes
        # ===================================================================
        insects = echoDataPlot[echoDataPlot$class %in% c("insect"), 
                               names(echoDataPlot) %in% c("time_stamp_targetTZ", 
                                                          "feature1.altitude_AGL", 
                                                          "class")]
        if (length(insects[, 1])){
          insects$class   = factor(insects$class, levels = classLevels)
          explorationPlot = explorationPlot + 
            ggplot2::geom_point(insects, 
                                mapping = ggplot2::aes(x      = time_stamp_targetTZ, 
                                                       y      = feature1.altitude_AGL, 
                                                       colour = class, 
                                                       shape  = class),
                                size   = 1, 
                                alpha = 0.7,
                                na.rm   = TRUE)
        }
        
        # overprint bird classes
        # ===================================================================
        birds = echoDataPlot[!(echoDataPlot$class %in% c("insect", 
                                                         "nonbio", 
                                                         "precipitation")), 
                             names(echoDataPlot) %in% c("time_stamp_targetTZ", 
                                                        "feature1.altitude_AGL", 
                                                        "class")]
        if (length(birds[, 1])){
          birds$class = factor(birds$class, levels = classLevels)
          explorationPlot = explorationPlot + 
            ggplot2::geom_point(birds, 
                                mapping = ggplot2::aes(x      = time_stamp_targetTZ, 
                                                       y      = feature1.altitude_AGL, 
                                                       colour = class, 
                                                       shape  = class ),
                                size   = 1, 
                                alpha = 0.7, 
                                na.rm = TRUE)
        }
        
        explorationPlot = explorationPlot + 
          ggplot2::scale_color_manual(values = classColors) +
          ggplot2::scale_shape_manual(values = classShapes) + 
          ggplot2::scale_fill_manual(values = backgroundColors) +
          ggplot2::coord_cartesian(ylim = yScale)
        
        explorationPlot = explorationPlot + 
          ggplot2::scale_x_datetime(date_breaks = "1 days", 
                                    labels = function(x) format(x, "%d-%b-%Y")) + 
          ggplot2::labs(fill = "", shape = "", colour = "") +
          ggplot2::ggtitle(label = "Exploration", 
                           subtitle = subtitle) + 
          ggplot2::xlab("Date") + 
          ggplot2::ylab("Altitude a.g.l [m]") +
          ggplot2::theme(plot.title     = ggplot2::element_text(size  = 12, 
                                                                face  = "bold", 
                                                                hjust = 0.5),
                         plot.subtitle = ggplot2::element_text(size  = 10, 
                                                               color = "grey40", 
                                                               hjust = 0.5),
                         axis.text.x   = ggplot2::element_text(angle = 90))
        
        # save plot
        # ===================================================================
        plotWidth_mm   = as.numeric(difftime(timeRange[[i]][2], 
                                             timeRange[[i]][1], 
                                             "days") * 30 + 50)
        plotHeight_mm  = 150
        if (plotWidth_mm < plotHeight_mm){
          plotWidth_mm = plotHeight_mm
        }
        savePlotToFile(plot           = explorationPlot, 
                       filePath      = filePath, 
                       plotType      = "exploration", 
                       plotWidth_mm  = plotWidth_mm, 
                       plotHeight_mm = plotHeight_mm, 
                       timeRange     = c(timeRange[[i]][1], 
                                         timeRange[[i]][2]))  
      }
    }
  }
}