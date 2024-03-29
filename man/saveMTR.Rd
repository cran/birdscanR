% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/saveMTR.R
\name{saveMTR}
\alias{saveMTR}
\title{saveMTR}
\usage{
saveMTR(
  mtr,
  filepath,
  fileName = NULL,
  fileNamePrefix = NULL,
  dbName = NULL,
  rotSelection = NULL,
  pulseTypeSelection = NULL,
  classAbbreviations = NULL
)
}
\arguments{
\item{mtr}{dataframe with MTR values created by the function \code{computeMTR}}

\item{filepath}{character string, path of the directory. If the directory
does not exist it will be created if possible.}

\item{fileName}{Filename (string) for the file. If not set, the filename
will be built using the input of the variables 'filenamePrefix', 'dbName',
'classAbbreviations', and other info in the 'mtr' data. If set, overrides
the automatic filename creation.}

\item{fileNamePrefix}{prefix of the filename (string). If not set, "mtr" is
used. Different information about the MTR data will be appended to the
filename.}

\item{dbName}{character string, name of the database. Used to create the
filename, if 'fileName' is not provided.}

\item{rotSelection}{numeric vector, rotation selection which was used to
filter protocols. Used to create the filename, if 'fileName' is not
provided. If not set, the rotation selection will not be appended to the
filename.}

\item{pulseTypeSelection}{character vector, pulse type selection which was
used to filter protocols. Used to create the filename, if 'fileName' is not
provided. If not set, the pulse type selection will not be appended to the
filename.}

\item{classAbbreviations}{Two-column dataframe with character first column
named 'class' and character second 'abbr', containing the full names of the
classes and their abbreviations to use in the output filename.
Default = NULL, meaning the abbreviations will be used that are stored in
the package; See data(classAbbreviations). Used to create the filename, if
'fileName' is not provided.}
}
\value{
No return value, used to save MTR to file.
}
\description{
saves MTR data to a .rds file in the directory \code{filepath}.
If the directory is not existing it will be created if possible.
}
\examples{
\dontrun{
# Set server, database, and other input settings
# ===========================================================================
  dbServer       = "MACHINE\\\\SERVERNAME"     # Set the name of your SQL server
  dbName         = "db_Name"                   # Set the name of your database
  dbDriverChar   = "SQL Server"                # Set either "SQL Server" or "PostgreSQL"
  mainOutputDir  = file.path(".", "results")
  radarTimeZone  = "Etc/GMT0"
  targetTimeZone = "Etc/GMT0"
  listOfRfFeaturesToExtract = c(167, 168)
  siteLocation   = c(47.494427, 8.716432)
  sunOrCivil     = "civil"
  timeRangeData       = c("2021-01-15 00:00", "2021-01-31 00:00")
 
# Get data
# ===========================================================================
  dbData = extractDbData(dbDriverChar                   = dbDriverChar,
                         dbServer                       = dbServer, 
                         dbName                         = dbName, 
                         saveDbToFile                   = TRUE,
                         dbDataDir                      = mainOutputDir,
                         radarTimeZone                  = radarTimeZone,
                         targetTimeZone                 = targetTimeZone,
                         listOfRfFeaturesToExtract      = listOfRfFeaturesToExtract,
                         siteLocation                   = siteLocation, 
                         sunOrCivil                     = sunOrCivil)
                         
# Get sunrise/sunset 
# ===========================================================================
  sunriseSunset = twilight(timeRange = timeRangeData,
                           latLon    = c(47.494427, 8.716432),
                           timeZone  = targetTimeZone)
                          
# Get manual blind times
# ===========================================================================
  data(manualBlindTimes)
  cManualBlindTimes = manualBlindTimes

# Compute migration traffic rate
# ===========================================================================
  classSelection.mtr = c("insect")
  mtrData = computeMTR(dbName                      = dbName, 
                       echoes                      = dbData$echoData, 
                       classSelection              = classSelection.mtr, 
                       altitudeRange               = c(25, 1025),
                       altitudeBinSize             = 50,
                       timeRange                   = timeRangeData, 
                       timeBinDuration_sec         = 1800,
                       timeZone                    = targetTimeZone,
                       sunriseSunset               = sunriseSunset,
                       sunOrCivil                  = "civil",
                       protocolData                = dbData$protocolData, 
                       visibilityData              = dbData$visibilityData,
                       manualBlindTimes            = cManualBlindTimes,
                       saveBlindTimes              = FALSE,
                       blindTimesOutputDir         = getwd(),
                       blindTimeAsMtrZero          = NULL,
                       propObsTimeCutoff           = 0, 
                       computePerDayNight          = FALSE, 
                       computeAltitudeDistribution = TRUE)   
                       
saveMTR(mtr      = mtrData,
        filepath = getwd())
}

}
\author{
Fabian Hertner, \email{fabian.hertner@swiss-birdradar.com};
Birgen Haest, \email{birgen.haest@vogelwarte.ch}
}
