## ----echo = FALSE-------------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## -----------------------------------------------------------------------------
  library(birdscanR)

## ----eval=FALSE---------------------------------------------------------------
#  # Set main output directory
#  # =============================================================================
#    mainOutputDir = file.path(".", "results")
#  
#  # Set server and database settings
#  # =============================================================================
#    dbServer       = "MACHINE\\SERVERNAME"       # Set the name of your SQL server
#    dbName         = "db_Name"                   # Set the name of your database
#    dbDriverChar   = "SQL Server"                # Set either "SQL Server" or "PostgreSQL"
#  
#  # Set timezone used by the radar/database
#  # Use "Etc/GMT0" (UTC) as radarTimeZone for birdscan v1.6
#  # and greater as all times are in UTC as of this software version.
#  # =============================================================================
#    radarTimeZone  = "Etc/GMT0"
#  
#  # Set target timezone for the radar/dataset
#  # Example: targetTimeZone = "Etc/GMT-1" (Etc/GMT-1 equals UTC+1)
#  # =============================================================================
#    targetTimeZone = "Etc/GMT0"
#  
#  # Set list of Rf features you also want to extract
#  # Vector with RF features to extract. Feature IDs can be found in the
#  # rffeatures table in the sql database.
#  # Example: Get wing beat frequency and credibility: c(167, 168)
#  # Set to NULL to not extract any.
#  # =============================================================================
#    listOfRfFeaturesToExtract = NULL
#  
#  # Geographic location of the radar measurements - c(Latitude, Longitude)
#  # =============================================================================
#    siteLocation = c(47.494427, 8.716432)
#  
#  # Set type of twilight to use for day/night decision, i.e., "sun" or "civil"
#  # =============================================================================
#    sunOrCivil = "civil"
#  
#  # Filter settings
#  # =============================================================================
#    # Set desired pulseLength modes
#      pulseLengthSelection = c("S")
#  
#    # Set desired rotation modes (multiple simultaneous selections possible)
#    # options: 1 (rotation), 0 (nonrotation)
#      rotationSelection    = c(1)
#  
#    # Set classes to use in the analysis
#    # Example: classSelection = c("passerine_type", "wader_type", "swift_type",
#    #                             "large_bird", "unid_bird", "bird_flock",
#    #                             "insect", "nonbio", "precipitation")
#      classSelection       = c("insect")
#  
#    # Set the classification propability cutoff (between 0 and 1) - only objects
#    # for which the chosen label also has a classification probability > than the
#    # cutoff are retained; Set to NULL to not subset according to probability.
#      classProbCutoff      = NULL
#  
#    # Set the altitude range (in meters agl)
#      altitudeRange        = c(50, 1000)
#  
#    # Set the time range for echodata (in the targetTimeZone)
#    # use format "yyyy-MM-dd hh:mm"
#      timeRangeData        = c("2021-01-15 00:00", "2021-01-31 00:00")
#  
#    # Set whether to get the manual blind time from:
#    # "mandb": the db file;
#    # "csv"  : a separate csv file
#      manBlindSource       = "csv"
#  
#    # Set paths to manual blind times file, if manBlindSource == "csv"
#      if (manBlindSource %in% "csv"){
#        manblindFile = file.path("data", "manualBlindTimes.csv")
#      }
#  
#    # Set whether to use the echoValidator - If set to TRUE, echoes labelled
#    # by the echo validator as “non-bio scatterer” will be excluded.
#      useEchoValidator = FALSE
#  
#  # MTR calculation settings
#  # =============================================================================
#    # Set whether to save the blind times to file
#      saveBlindTimes = TRUE
#  
#    # Set altitude Range and Bin Size for the MTR calculations
#      altitudeRange.mtr = c(25, 1025)
#      altitudeBinSize   = 50
#  
#    # time range for timeBins (targetTimeZone) - format: "yyyy-MM-dd hh:mm"
#      timeRangesTimeBins  = c("2021-01-15 00:00", "2021-01-31 00:00")
#  
#    # timeBin size in seconds
#      timeBinduration_sec = 3600
#  
#    # set blindtime types which should not be treated as blindtime but MTR = 0
#      blindTimeAsMtrZero = c("rain")
#  
#    # cutoff for proportional observation times: Ignore TimeBins where
#    # "observationTime/timeBinDuration < propObsTimeCutoff"
#    # in 'computeMTR' only used if parameter 'computePerDayNight' is set to
#    # 'TRUE' and timeBins are shorter than day/night. In this case timeBins
#    # are combined by day/night and only time bins with a proportional
#    # observation time greater than the cutoff will be used to compute the
#    # day/night MTR and spread.
#    # set value from 0-1
#      propObsTimeCutoff = 0.2
#  
#    # Set classes for which you want the MTR
#    # Example: classSelection = c("passerine_type", "wader_type", "large_bird")
#      # classSelection = c("passerine_type", "wader_type", "swift_type",
#      #                    "large_bird", "unid_bird", "bird_flock",
#      #                    "insect", "nonbio", "precipitation")
#      classSelection.mtr = c("insect")
#  
#    # Set whether to compute MTR per timebin or per day/night
#    # TRUE: MTR is computed per day and night;
#    # FALSE: MTR is computed for each time bin
#      computePerDayNight = FALSE
#  
#    # Set whether to save the MTR to file
#      saveMTR2File = TRUE

## ----eval=FALSE---------------------------------------------------------------
#  # Print progress message
#  # =============================================================================
#    message(paste0("Extracting data from ", dbName))
#  
#  # Get data
#  # =============================================================================
#    dbData = extractDbData(dbDriverChar                   = dbDriverChar,
#                           dbServer                       = dbServer,
#                           dbName                         = dbName,
#                           saveDbToFile                   = TRUE,
#                           dbDataDir                      = mainOutputDir,
#                           radarTimeZone                  = radarTimeZone,
#                           targetTimeZone                 = targetTimeZone,
#                           listOfRfFeaturesToExtract      = listOfRfFeaturesToExtract,
#                           siteLocation                   = siteLocation,
#                           sunOrCivil                     = sunOrCivil)
#  
#  # Print progress message
#  # =============================================================================
#    message(paste0("Finished extracting data from ", dbName))

## ----eval=FALSE---------------------------------------------------------------
#  # Print progress message
#  # =============================================================================
#    message(paste0("Filtering data from ", dbName))
#  
#  # Get current manual blind times
#  # =============================================================================
#    # CASE: manBlindSource == "csv"
#    # ===========================================================================
#      if (manBlindSource %in% "csv"){
#        # Read manual blindtimes from csv File
#        # csv contains one row per blindtime and 3 columns
#        # (start of blindtime, stop of blindtime, type of blindtime)
#        # times have to be of format 'yyyy-MM-dd hh:mm:ss'
#        # =======================================================================
#          cManualBlindTimes = loadManualBlindTimes(filePath     = manblindFile,
#                                                   blindTimesTZ = radarTimeZone,
#                                                   targetTZ     = targetTimeZone)
#    # CASE: manBlindSource == "mandb"
#    # ===========================================================================
#      } else if (manBlindSource %in% "mandb"){
#        cManualBlindTimes = dbData$manualVisibilityTable
#      }
#  
#  # Filter the data
#  # =============================================================================
#    filteredEchoProtocol = filterData(echoData           = dbData$echoData,
#                                      protocolData       = dbData$protocolData,
#                                      pulseTypeSelection = pulseLengthSelection,
#                                      rotationSelection  = rotationSelection,
#                                      timeRangeTargetTZ  = timeRangeData,
#                                      targetTimeZone     = targetTimeZone,
#                                      classSelection     = classSelection,
#                                      classProbCutOff    = classProbCutoff,
#                                      altitudeRange_AGL  = altitudeRange,
#                                      manualBlindTimes   = cManualBlindTimes,
#                                      echoValidator      = useEchoValidator)
#  
#  # Save the filtered echo and protocol data to the database data list
#  # =============================================================================
#    dbData$echoData     = filteredEchoProtocol$echoData
#    dbData$protocolData = filteredEchoProtocol$protocolData
#  
#  # Save the filtered dataset to a file, including also all filter settings,
#  # and the other tables in the original dataset
#  # =============================================================================
#    dbData$echoFiltersApplied = list(classProbCutoff    = classProbCutoff,
#                                     altitudeRange_AGL  = altitudeRange,
#                                     targetTimeZone     = targetTimeZone,
#                                     timeRangeEchoData  = timeRangeData,
#                                     useEchoValidator   = useEchoValidator)
#    if (is.null(classProbCutoff)){classProbCutoff.char = 0} else {classProbCutoff.char = classProbCutoff}
#    outputFile = file.path(mainOutputDir,
#                           paste0(dbName, "_filtered_",
#                                  "cut", classProbCutoff.char, "_",
#                                  "altRange", paste(altitudeRange, collapse = "to"), "_",
#                                  "timeRange", paste(format(as.Date(timeRangeData), "%Y%m%d"),
#                                                     collapse = "to"),
#                                  "_",
#                                  "echoVal", as.character(useEchoValidator),
#                                  ".rds"))
#    saveRDS(dbData, outputFile)
#  
#  # Print progress message
#  # =============================================================================
#    message(paste0("Finished filtering data from ", dbName))
#  

## ----eval=FALSE---------------------------------------------------------------
#  # Print information message
#  # =====================================================================
#    if (computePerDayNight){
#      message(paste0("Computing MTR for ", dbName, ", using:\n",
#                     "Classes: ", paste(classSelection.mtr, collapse = ", "), "\n",
#                     "For altitudes: ", paste(altitudeRange.mtr, collapse = " to "),
#                     " in bins of ", altitudeBinSize, "m\n",
#                     "on a nightly/daily basis"))
#    } else {
#      message(paste0("Computing MTR for ", dbName, ", using:\n",
#                     "Classes: ", paste(classSelection.mtr, collapse = ", "), "\n",
#                     "For altitudes: ", paste(altitudeRange.mtr, collapse = " to "),
#                     " in bins of ", altitudeBinSize, "m\n",
#                     "Timebins of: ", timeBinduration_sec, " seconds or ",
#                     timeBinduration_sec/3600, " hours"))
#    }
#  
#  # Calculate the MTR
#  # =====================================================================
#    mtr = computeMTR(dbName                      = dbName,
#                     echoes                      = dbData$echoData,
#                     classSelection              = classSelection.mtr,
#                     altitudeRange               = altitudeRange.mtr,
#                     altitudeBinSize             = altitudeBinSize,
#                     timeRange                   = timeRangesTimeBins,
#                     timeBinDuration_sec         = timeBinduration_sec,
#                     timeZone                    = targetTimeZone,
#                     sunriseSunset               = dbData$sunriseSunset,
#                     sunOrCivil                  = sunOrCivil,
#                     protocolData                = dbData$protocolData,
#                     visibilityData              = dbData$visibilityData,
#                     manualBlindTimes            = cManualBlindTimes,
#                     saveBlindTimes              = saveBlindTimes,
#                     blindTimesOutputDir         = mainOutputDir,
#                     blindTimeAsMtrZero          = blindTimeAsMtrZero,
#                     propObsTimeCutoff           = propObsTimeCutoff,
#                     computePerDayNight          = computePerDayNight,
#                     computeAltitudeDistribution = TRUE)
#  
#  # Save the mTR to file, if requested
#  # =====================================================================
#    if (saveMTR2File){
#      if (computePerDayNight){
#        outputFile = paste0("mtr_", dbName,
#                             "_alt", paste(altitudeRange.mtr,
#                                           collapse = "to"),
#                             "per", altitudeBinSize, "m_",
#                             "time",
#                             paste(format(as.Date(timeRangesTimeBins), "%Y%m%d"),
#                                   collapse = "to"),
#                             "perDayNight_",
#                             "cut", propObsTimeCutoff, ".rds")
#      } else {
#        outputFile = paste0("mtr_", dbName,
#                      "_alt", paste(altitudeRange.mtr,
#                                    collapse = "to"),
#                      "per", altitudeBinSize, "m_",
#                      "time", paste(format(as.Date(timeRangesTimeBins), "%Y%m%d"),
#                                    collapse = "to"),
#                      "per", timeBinduration_sec, "s_",
#                      "cut", propObsTimeCutoff, ".rds")
#      }
#      saveMTR(mtr                = mtr,
#              filepath           = mainOutputDir,
#              fileName           = outputFile)
#    }
#  

## ----eval=FALSE---------------------------------------------------------------
#  # Make time series plot
#  # =============================================================================
#    # Set time range for plots (in targetTimeZone) ;
#    # A plot is created for each timerange
#    # use format "yyyy-MM-dd hh:mm"
#    # ===========================================================================
#      timeRangePlot  = list(c("2021-01-15 00:00", "2021-01-22 00:00"),
#                            c("2021-01-23 00:00", "2021-01-31 00:00"))
#  
#    # Set output path for plots
#    # ===========================================================================
#      outputDir.plots = file.path(mainOutputDir, "Plots")
#  
#    # Set the class of which the MTR data should be plotted.
#    # If not set or set to “allClasses”, MTR of all classes will be plotted.
#    # ===========================================================================
#      plotClass = "allClasses"
#  
#    # Set the maximum value of the y-Scale of the plot to the given value.
#    # If negative or not set, the y-Scale is auto-scaled.
#    # ===========================================================================
#      maxMTR.plot = -1
#  
#    # Set the propObsTimeCutOff for the plot
#    # Time bins with a proportional observation time smaller than
#    # propObsTimeCutoff will not be shown in the plot
#    # ===========================================================================
#      propObsTimeCutoff.plot = 0.2
#  
#    # Set if the spread (first and third quartile) should be plotted
#    # ===========================================================================
#      plotSpread = TRUE
#  
#    # Print message
#    # ===========================================================================
#      message("Plotting time series of MTR values..")
#  
#    # Make Plot
#    # ===========================================================================
#      plotLongitudinalMTR(mtr               = mtr,
#                          maxMTR            = maxMTR.plot,
#                          timeRange         = timeRangePlot,
#                          targetTimeZone    = "Etc/GMT0",
#                          plotClass         = plotClass,
#                          propObsTimeCutoff = propObsTimeCutoff.plot,
#                          plotSpread        = plotSpread,
#                          filePath          = outputDir.plots)
#  

## ----eval=FALSE---------------------------------------------------------------
#  # Make an exploration plot
#  # =============================================================================
#    # Set  the maximum value of the y-Scale of the plot to the given value.
#    # If negative or not set, the y-Scale is auto-scaled.
#      maxAltitude.plot = -1
#  
#    # Print message
#    # ===========================================================================
#      message("Plotting exploration..")
#  
#    # Make Plot
#    # ===========================================================================
#      plotExploration(echoData         = dbData$echoData,
#                      timeRange        = timeRangePlot,
#                      targetTimeZone   = "Etc/GMT0",
#                      manualBlindTimes = cManualBlindTimes,
#                      visibilityData   = dbData$visibilityData,
#                      protocolData     = dbData$protocolData,
#                      sunriseSunset    = dbData$sunriseSunset,
#                      maxAltitude      = maxAltitude.plot,
#                      filePath         = outputDir.plots)
#  

